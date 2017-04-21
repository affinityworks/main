require 'test_helper'

class Api::ActionNetwork::AttendancesTest < ActiveSupport::TestCase
  test '.import!' do
    group = Group.first

    stub_request(:get, 'https://actionnetwork.org/api/v2/events/1efc3644-af25-4253-90b8-a0baf12dbd1e/attendances')
      .with(headers: { 'OSDI-API-TOKEN' => group.an_api_key })
      .to_return(body: File.read(Rails.root.join('test', 'fixtures', 'files', 'attendances.json')))

    stub_request(:get, "https://actionnetwork.org/api/v2/events/1efc3644-af25-4253-90b8-a0baf12dbd1e/attendances").
      with(:headers => {'Accept'=>'application/json', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Type'=>'application/json', 'Osdi-Api-Token'=>'c96dc7a808ed80fca8bb4953f8ac10bf', 'User-Agent'=>'Ruby'}).
      to_return(body: File.read(Rails.root.join('test', 'fixtures', 'files', 'attendances.json')))

    Person.create!(identifiers: ['action_network:ceef7e23-4617-4af8-bd0f-60029299d8cd'])
    Person.create!(identifiers: ['action_network:06d13a33-6824-493b-a922-95e793f269d3'])
    event = Event.any_identifier('action_network:1efc3644-af25-4253-90b8-a0baf12dbd1e').first!

    person_count = Person.count
    assert_difference 'Attendance.count', 2 do
      Api::ActionNetwork::Attendances.import!(event, group)
    end

    assert_equal person_count, Person.count, 'Person.count. Should not create any new people.'
    assert_equal 2, event.attendances.reload.size

    assert event.attendances.any? { |a| a.person.identifier?('action_network:ceef7e23-4617-4af8-bd0f-60029299d8cd') }
    assert event.attendances.any? { |a| a.person.identifier?('action_network:06d13a33-6824-493b-a922-95e793f269d3') }
  end
end
