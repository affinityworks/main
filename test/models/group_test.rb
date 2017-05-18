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

    assert_difference 'group.events.count', 2, 'Imports the events' do
      assert_difference 'group.members.count', 5, 'Imports the membmers' do
        assert_difference 'Attendance.count', 2, 'Imports the attendances' do
          group.sync_with_action_network
        end
      end
    end
  end

  test '#upcoming_events' do
    group = Group.first
    ended_event = Event.create(start_date: 2.days.ago)
    upcoming_event_1 = Event.create(start_date: Date.today)
    other_group_event = Event.create(start_date: Date.today)
    upcoming_event_2 = Event.create(start_date: Date.today + 2.days)
    future_event = Event.create(start_date: Date.today + (Event::UPCOMING_EVENTS_DAYS + 1).days)

    group.events = [ended_event, upcoming_event_1, upcoming_event_2, future_event]

    assert_equal group.upcoming_events, [upcoming_event_1, upcoming_event_2]
  end
end
