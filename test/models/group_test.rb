require_relative '../test_helper'

class GroupTest < ActiveSupport::TestCase
  test "basic person associations" do
    one = groups(:one)
    assert_kind_of Group, one
    assert_kind_of AdvocacyCampaign, one.advocacy_campaigns.first
    assert_kind_of CanvassingEffort, one.canvassing_efforts.first
    assert_kind_of Petition, one.petitions.first
    assert_kind_of SharePage, one.share_pages.first
    assert_kind_of Form, one.forms.first
    assert_kind_of Person, one.creator
    assert_kind_of Person, one.modified_by
    assert_kind_of Person, one.members.first
    assert_kind_of Event, one.events.first
  end

  test "sync_with_action_network" do
    group = Group.first

    # first request. It should return another page in the next section
    stub_request(:get, "https://actionnetwork.org/api/v2/events?filter=origin_system eq 'Action Network'")
      .with(headers: { 'OSDI-API-TOKEN' => group.an_api_key })
      .to_return(body: File.read(Rails.root.join('test', 'fixtures', 'files', 'events.json')))


    # # second request. It should not return another page in the next section
    stub_request(:get, "https://actionnetwork.org/api/v2/events?filter=origin_system eq 'Action Network'&page=2")
      .with(headers: { 'OSDI-API-TOKEN' => group.an_api_key })
      .to_return(body: File.read(Rails.root.join('test', 'fixtures', 'files', 'events_page_2.json')))

    stub_request(:get, 'https://actionnetwork.org/api/v2/people')
      .with(headers: { 'OSDI-API-TOKEN' => group.an_api_key })
      .to_return(body: File.read(Rails.root.join('test', 'fixtures', 'files', 'people.json')))

    stub_request(:get, 'https://actionnetwork.org/api/v2/people?page=2')
      .with(headers: { 'OSDI-API-TOKEN' => group.an_api_key })
      .to_return(body: File.read(Rails.root.join('test', 'fixtures', 'files', 'people_page_2.json')))

    stub_request(:get, "https://actionnetwork.org/api/v2/events/a01e94bf-f132-41c1-a1be-358cc7757119/attendances").
      with(:headers => {'Accept'=>'application/json', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Type'=>'application/json', 'Osdi-Api-Token'=>'test-token', 'User-Agent'=>'Ruby'}).
      to_return(:status => 200, :body => "", :headers => {})


    stub_request(:post, 'https://actionnetwork.org/api/v2/events').to_return(status: 200)

    %w(
      bc82a374-fba9-4f47-8e6b-96fdd8350ca2
      1efc3644-af25-4253-90b8-a0baf12dbd1e
      a3c724db-2799-49a6-970a-7c3c0844645d
      d91b4b2e-ae0e-4cd3-9ed7-d0ec501b0bc3
      d91b4b2e-ae0e-4cd3-9ed7-d0ec501b0bd4
    ).each do |event_id|
      stub_request(:get, "https://actionnetwork.org/api/v2/events/#{event_id}/attendances")
        .with(headers: { 'OSDI-API-TOKEN' => group.an_api_key })
        .to_return(body: File.read(Rails.root.join('test', 'fixtures', 'files', 'attendances.json')))
    end

    %w(
      06d13a33-6824-493b-a922-95e793f269d3
      ceef7e23-4617-4af8-bd0f-60029299d8cd
    ).each do |person_id|
      stub_request(:get, "https://actionnetwork.org/api/v2/people/#{person_id}").
      with(headers: { 'OSDI-API-TOKEN' => group.an_api_key }).
      to_return(body: File.read(Rails.root.join('test', 'fixtures', 'files', 'person.json')))
    end

    tag_uid = '480cd227-7490-44db-90ec-81cd47483745'
    person_uid = '636c4f79-2fde-4a6b-9ef3-276801f63315'
    stub_request(:get, "https://actionnetwork.org/api/v2/tags")
      .with(:headers => {'Accept'=>'application/json', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Type'=>'application/json', 'Osdi-Api-Token'=>'test-token', 'User-Agent'=>'Ruby'})
      .to_return(body: File.read(Rails.root.join('test', 'fixtures', 'files', 'tags.json')))
    stub_request(:get, "https://actionnetwork.org/api/v2/tags/#{tag_uid}/taggings")
      .with(:headers => {'Accept'=>'application/json', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Type'=>'application/json', 'Osdi-Api-Token'=>'test-token', 'User-Agent'=>'Ruby'})
      .to_return(body: File.read(Rails.root.join('test', 'fixtures', 'files', 'taggings.json')))
    stub_request(:get, "https://actionnetwork.org/api/v2/people/#{person_uid}")
      .with(:headers => {'Accept'=>'application/json', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Type'=>'application/json', 'Osdi-Api-Token'=>'test-token', 'User-Agent'=>'Ruby'})
      .to_return(body: File.read(Rails.root.join('test', 'fixtures', 'files', 'person.json')))

    assert_difference 'group.events.count', 3, 'Imports the events' do
      assert_difference 'group.members.count', 6, 'Imports the membmers' do
        assert_difference 'Attendance.count', 2, 'Imports the attendances' do
          perform_enqueued_jobs do
            group.sync_with_action_network
          end
        end
      end
    end
  end

  test '#upcoming_events' do
    group = groups(:five)
    other_group = groups(:six)

    ended_event = Event.create(origin_system: 'origin_system', title: 'title', start_date: 2.days.ago)
    group.events<<ended_event

    upcoming_event_1 = Event.create(origin_system: 'origin_system', title: 'title', start_date: Date.today)
    group.events<<upcoming_event_1

    other_group_event = Event.create(origin_system: 'origin_system', title: 'title', start_date: Date.today)
    other_group.events<<upcoming_event_1

    upcoming_event_2 = Event.create(origin_system: 'origin_system', title: 'title', start_date: Date.today + 2.days)
    group.events<<upcoming_event_2

    future_event = Event.create(origin_system: 'origin_system', title: 'title', start_date: Date.today + (Event::UPCOMING_EVENTS_DAYS + 1).days)
    group.events<<future_event

    group.events = [ended_event, upcoming_event_1, upcoming_event_2, future_event]

    assert_includes group.upcoming_events, upcoming_event_1
    assert_includes group.upcoming_events, upcoming_event_2
    refute_includes group.upcoming_events, other_group_event
    refute_includes group.upcoming_events, future_event
  end

  test 'correctly destroying groups' do
    group = groups(:test)
    memberships = group.members
    assert memberships.any?
    group.destroy
    assert memberships.empty?
  end

  test '#all_events' do
    group = groups(:one)
    affiliated = groups(:two)

    Affiliation.create(group: group, affiliated: affiliated)

    group_event = Event.create(origin_system: 'origin_system', title: 'title')
    group.events.push(group_event)
    affiliated_event = Event.create(origin_system: 'origin_system', title: 'title')
    affiliated.events.push(affiliated_event)

    assert_includes group.all_events, group_event
    assert_includes group.all_events, affiliated_event
    assert_equal group.all_events.count, group.events.count + affiliated.events.count
  end

  test '#all_memberships' do
    group = Group.create(:an_api_key => "asdfasdf", name: "Test")
    affiliated = Group.create(:an_api_key => 'fdafdafda', name: "Affiliated Group")

    Affiliation.create(group: group, affiliated: affiliated)
    membership = Person.create(given_name: 'given_name', family_name: 'family_name')
    group_membership = Membership.create(person: membership)
    group.memberships.push(group_membership)
    affiliated_membership = Membership.create(person: Person.create)
    affiliated.memberships.push(affiliated_membership)

    assert_includes group.all_memberships, group_membership
    assert_includes group.all_memberships, affiliated_membership
    assert_equal group.all_memberships.count, group.memberships.count + affiliated.memberships.count
  end

  test '#all_members' do
    group = Group.create(:an_api_key => "asdfasdf", name: "Test")
    affiliated = Group.create(:an_api_key => 'fdafdafda', name: "Affiliated Group")

    Affiliation.create(group: group, affiliated: affiliated)

    group_member = Person.create(given_name: 'given_name', family_name: 'family_name')
    group.members.push(group_member)
    affiliated_member = Person.create(given_name: 'given_name', family_name: 'family_name')
    affiliated.members.push(affiliated_member)

    assert_includes group.all_members, group_member
    assert_includes group.all_members, affiliated_member
    assert_equal group.all_members.count, (affiliated.members.pluck(:id) + group.members.pluck(:id)).uniq.count
  end

  test '#member?' do
    group = Group.create(:an_api_key => "asdfasdf", name: "test")

    group_member = Person.create(given_name: 'given_name', family_name: 'family_name')
    no_group_member = Person.create(given_name: 'no_member', family_name: 'no_member')
    organizer = Person.create(given_name: 'organizer', family_name: 'organizer')

    group_membership = Membership.create(person: organizer, role: 'organizer')
    group.members.push(group_member)
    group.memberships.push(group_membership)

    assert group.member?(group_member)
    assert_not group.member?(no_group_member)
    assert_not group.member?(organizer)

  end

  test '#affiliation_with_role?' do
    membership = memberships(:forth)
    membership_admin = memberships(:admin)

    group = groups(:test)
    group_fourth = groups(:fourth)

    person = people(:one)
    person_admin = people(:admin)

    member_role = Membership.roles[:member]
    organizer_role = Membership.roles[:organizer]
    volunteer_role = Membership.roles[:volunteer]

    membership.update(role: member_role)
    membership_admin.update(role: member_role)

    assert group.affiliation_with_role(person, member_role), group
    assert group_fourth.affiliation_with_role(person_admin, member_role), group

    membership.update(role: organizer_role)
    membership_admin.update(role: organizer_role)

    assert group.affiliation_with_role(person, organizer_role), group
    assert group_fourth.affiliation_with_role(person_admin, organizer_role), group

    membership.update(role: volunteer_role)
    membership_admin.update(role: volunteer_role)

    assert group.affiliation_with_role(person, volunteer_role), group
    assert group_fourth.affiliation_with_role(person_admin, volunteer_role), group

  end

  describe "accessors" do
      it "returns the group's signup page url" do
      groups(:fantastic_four)
        .signup_url
        .must_equal 'http://localhost:3000' +
                    '/groups/1036040811' +
                    '/signup_forms/350404309/signups/new'
    end
  end

  describe "nested attributes" do

    it "accepts nested attributes for location" do
      assert_difference "Address.count", 1 do
        Group.create(
          name: "foogroup",
          location_attributes: {
            postal_code: "90210"
          }
        )
      end
    end
  end

  describe "#create_subgroup" do
    let(:group){ groups(:one) }
    let(:group_count){ Group.count }
    let(:address_count){ Address.count }
    let(:affiliation_count){ Affiliation.count }
    let(:count_all){
      group_count
      address_count
      affiliation_count
    }

    before do
      count_all
      @subgroup = group.create_subgroup(
        name: "trystero",
        location_attributes: {
          postal_code: "90210"
        }
      )
    end

    describe "group is valid" do
      it "returns the group" do
        @subgroup.valid?.must_equal true
      end

      it "creates a child group" do
        Group.count.must_equal(group_count + 1)
      end

      it "creates a location" do
        Address.count.must_equal(address_count + 1)
      end

      it "creates an affiliation" do
        Affiliation.count.must_equal(affiliation_count + 1)
      end

      it "affiliates the subgroup with the group" do
        Group.last.affiliated_with.last.must_equal(group)
      end

      it "affiliates the group with the subgroup" do
        group.affiliates.last.must_equal(Group.last)
      end
    end

    describe "group is invalid" do
      it "builds a Group with errors" do
        subgroup = group.create_subgroup(name: nil)
        subgroup.valid?.must_equal false
      end
    end


    describe "network membership cloning" do

      describe "group has no networks" do
        it "assigns no network memberships" do
          @subgroup.networks.must_be_empty
        end
      end

      describe "group has primary network" do
        let(:group){ groups(:ohio_chapter) }

        it "assings subgroup primary membership in network" do
          @subgroup.primary_network.must_equal networks(:national_network)
        end
      end
    end
  end

  describe "#create_subgroup_with_organizer" do
    let(:group){ groups(:one) }
    let(:person_count){ Person.count }
    let(:membership_count){ Membership.count }
    let(:email_count){ EmailAddress.count }
    let(:phone_count){ PhoneNumber.count }
    let(:affiliation_count){ Affiliation.count }
    let(:count_all){
      person_count
      email_count
      phone_count
      membership_count
      affiliation_count
    }

    before do
      count_all
      @subgroup, @organizer = group.create_subgroup_with_organizer(
        subgroup_attrs:
          { name: "trystero", location_attributes: { postal_code: "90210" } },
        organizer_attrs:
          { family_name: 'Mould',
            given_name: 'Bob',
            email_addresses_attributes: [{ address: 'foo@bar.com' }],
            phone_numbers_attributes: [{ number: '212-987-6543' }] }
      )
    end

    describe "group is valid" do
      it "returns a valid group" do
        @subgroup.must_be_instance_of Group
        @subgroup.valid?.must_equal true
      end

      it "returns a valid organizer" do
        @organizer.must_be_instance_of Person
        @organizer.valid?.must_equal true
      end

      it "creates a organizer for the group" do
        Person.count.must_equal(person_count + 1)
        Person.last.given_name.must_equal "Bob"
      end

      it "makes the organizer a member of the group" do
        Person.last.groups.last.must_equal @subgroup
        Group.last.members.last.must_equal Person.last
      end

      it "creates a new affiliation" do
        Affiliation.count.must_equal(affiliation_count + 1)
      end

      it "creates a new membership" do
        Membership.count.must_equal(membership_count + 1)
      end

      it "creates email for organizer" do
        EmailAddress.count.must_equal(email_count + 1)
      end

      it "creates phone number for organizer" do
        PhoneNumber.count.must_equal(phone_count + 1)
      end
    end

    describe "group has primary network" do
      it ""
    end

    describe "group is not valid" do
      # TODO ---v
      it "provides error messages for nested attributes"
    end
  end

  describe "#add_membership" do
    let(:group){ groups(:one) }
    let(:membership_count){ Membership.count }
    let(:person_count){ Person.count }

    before do
      membership_count
      person_count
      @membership = group.add_member(
        member: Person.new(family_name: "Watt", given_name: "Mike"),
        role: 'organizer'
      )
    end

    it "creates a membership" do
      Membership.count.must_equal(membership_count + 1)
    end

    describe "organizer" do
      it "creates a person" do
        Person.count.must_equal(person_count + 1)
      end

      it "sets the membership role to organizer" do
        @membership.role.must_equal('organizer')
      end
    end

  end

  #test for model method to be written - is failing
    # test 'current_group_members' do
    #   group = Group.first
    #   affiliated = Group.last
    #   Affiliation.create(group: group, afilliated: affiliated)

    #   group_member = Person.create
    #   group.members.push(group_member)
    #   affiliated_member = Person.create
    #   affiliated.members.push(affiliated_member)

    #   assert_includes group.current_group_members, group_member
    #   assert_not group.current_group_members, affiliated_member
    #   assert_not_equal group.current_group_members.count, group.members.count + affiliated.members.count
    # end

  def url
    "https://actionnetwork.org/api/v2/events?filter=origin_system eq 'Affinity'"
  end

end
