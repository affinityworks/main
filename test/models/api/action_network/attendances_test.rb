require 'test_helper'

class Api::ActionNetwork::AttendancesTest < ActiveSupport::TestCase
  test '.import!' do
    group = Group.first

    attendances_response = File.read(Rails.root.join('test', 'fixtures', 'files', 'attendances.json'))

    stub_request(:get, 'https://actionnetwork.org/api/v2/events/1efc3644-af25-4253-90b8-a0baf12dbd1e/attendances')
      .with(headers: { 'OSDI-API-TOKEN' => group.an_api_key })
      .to_return(body: attendances_response)

    stub_request(:get, "https://actionnetwork.org/api/v2/people/06d13a33-6824-493b-a922-95e793f269d3").
      with(:headers => {'Accept'=>'application/json', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Type'=>'application/json', 'Osdi-Api-Token'=>'test-token', 'User-Agent'=>'Ruby'}).
      to_return(body: File.read(Rails.root.join('test', 'fixtures', 'files', 'person.json')))

    Person.create!(identifiers: ['action_network:ceef7e23-4617-4af8-bd0f-60029299d8cd'],
      given_name: 'given_name', family_name: 'family_name')
    event = Event.any_identifier('action_network:1efc3644-af25-4253-90b8-a0baf12dbd1e').first!

    action_network_attendances = JSON.parse(attendances_response)['_embedded']['osdi:attendances']
    person_count = Person.count

    #this tracks that attendances have been added but not duplicates
    added_attendances_count = action_network_attendances.size - 1
    assert_difference 'Attendance.count', added_attendances_count do
      Api::ActionNetwork::Attendances.import!(event, group)
    end

    assert_equal person_count + 1, Person.count, 'Creates the not imported person.'
    assert_equal added_attendances_count, event.attendances.reload.size

    assert event.attendances.any? { |a| a.person.identifier?('action_network:ceef7e23-4617-4af8-bd0f-60029299d8cd') }
    assert event.attendances.any? { |a| a.person.identifier?('action_network:06d13a33-6824-493b-a922-95e793f269d3') }
    assert_includes event.attendances.last.origins, Origin.action_network
  end
end
