require 'test_helper'

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

    stub_request(:get, 'https://actionnetwork.org/api/v2/events')
      .with(headers: { 'OSDI-API-TOKEN' => group.an_api_key })
      .to_return(body: File.read(Rails.root.join('test', 'fixtures', 'files', 'events.json')))

    stub_request(:get, 'https://actionnetwork.org/api/v2/events?page=2')
      .with(headers: { 'OSDI-API-TOKEN' => group.an_api_key })
      .to_return(body: File.read(Rails.root.join('test', 'fixtures', 'files', 'events_page_2.json')))

    stub_request(:get, 'https://actionnetwork.org/api/v2/people')
      .with(headers: { 'OSDI-API-TOKEN' => group.an_api_key })
      .to_return(body: File.read(Rails.root.join('test', 'fixtures', 'files', 'people.json')))

    stub_request(:get, 'https://actionnetwork.org/api/v2/people?page=2')
      .with(headers: { 'OSDI-API-TOKEN' => group.an_api_key })
      .to_return(body: File.read(Rails.root.join('test', 'fixtures', 'files', 'people_page_2.json')))

    %w(
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
          group.sync_with_action_network
        end
      end
    end
  end

  test '#upcoming_events' do
    group = Group.first
    other_group = Group.last

    ended_event = Event.create(start_date: 2.days.ago)
    group.events<<ended_event

    upcoming_event_1 = Event.create(start_date: Date.today)
    group.events<<upcoming_event_1

    other_group_event = Event.create(start_date: Date.today)
    other_group.events<<upcoming_event_1

    upcoming_event_2 = Event.create(start_date: Date.today + 2.days)
    group.events<<upcoming_event_2

    future_event = Event.create(start_date: Date.today + (Event::UPCOMING_EVENTS_DAYS + 1).days)
    group.events<<future_event

    group.events = [ended_event, upcoming_event_1, upcoming_event_2, future_event]

    assert_includes group.upcoming_events, upcoming_event_1
    assert_includes group.upcoming_events, upcoming_event_2
    refute_includes group.upcoming_events, other_group_event
    refute_includes group.upcoming_events, future_event
  end

  test '#all_events' do
    group = Group.first
    affiliated = Group.last

    Affiliation.create(group: group, affiliated: affiliated)

    group_event = Event.create
    group.events.push(group_event)
    affiliated_event = Event.create
    affiliated.events.push(affiliated_event)

    assert_includes group.all_events, group_event
    assert_includes group.all_events, affiliated_event
    assert_equal group.all_events.count, group.events.count + affiliated.events.count
  end

  test '#all_memberships' do
    group = Group.first
    affiliated = Group.last

    Affiliation.create(group: group, affiliated: affiliated)

    group_membership = Membership.create(person: Person.create)
    group.memberships.push(group_membership)
    affiliated_membership = Membership.create(person: Person.create)
    affiliated.memberships.push(affiliated_membership)

    assert_includes group.all_memberships, group_membership
    assert_includes group.all_memberships, affiliated_membership
    assert_equal group.all_memberships.count, group.memberships.count + affiliated.memberships.count
  end

  test '#all_members' do
    group = Group.first
    affiliated = Group.last

    Affiliation.create(group: group, affiliated: affiliated)

    group_member = Person.create
    group.members.push(group_member)
    affiliated_member = Person.create
    affiliated.members.push(affiliated_member)

    assert_includes group.all_members, group_member
    assert_includes group.all_members, affiliated_member
    assert_equal group.all_members.count, group.members.count + affiliated.members.count
  end
end
