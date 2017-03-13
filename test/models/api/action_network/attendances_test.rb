require 'test_helper'

class Api::ActionNetwork::AttendancesTest < ActiveSupport::TestCase
  test '.import!' do
    stub_request(:get, 'https://actionnetwork.org/api/v2/events/1efc3644-af25-4253-90b8-a0baf12dbd1e/attendances')
      .with(headers: { 'OSDI-API-TOKEN' => 'test-token' })
      .to_return(body: File.read(Rails.root.join('test', 'fixtures', 'files', 'attendances.json')))

    Person.create!(identifiers: ['action_network:ceef7e23-4617-4af8-bd0f-60029299d8cd'])
    Person.create!(identifiers: ['action_network:06d13a33-6824-493b-a922-95e793f269d3'])
    event = Event.any_identifier('action_network:1efc3644-af25-4253-90b8-a0baf12dbd1e').first!

    person_count = Person.count
    assert_difference 'Attendance.count', 2 do
      Api::ActionNetwork::Attendances.import! event
    end

    assert_equal person_count, Person.count, 'Person.count. Should not create any new people.'
    assert_equal 2, event.attendances.reload.size

    assert event.attendances.any? { |a| a.person.identifier?('action_network:ceef7e23-4617-4af8-bd0f-60029299d8cd') }
    assert event.attendances.any? { |a| a.person.identifier?('action_network:06d13a33-6824-493b-a922-95e793f269d3') }
  end
end
