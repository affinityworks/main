require 'test_helper'

class Api::EventsTest < ActiveSupport::TestCase
  test '.import!' do
    stub_request(:get, 'https://actionnetwork.org/api/v2/events')
      .with(headers: { 'OSDI-API-TOKEN' => 'test-token' })
      .to_return(body: File.read("#{Rails.root}/test/fixtures/files/events.json"))

    travel_to Time.zone.local(2001) do
      Event.create!(
        title: 'TBD',
        identifiers: ['action_network:a3c724db-2799-49a6-970a-7c3c0844645d']
      )
    end

    assert Event.where(title: 'House Party for Progress').exists
    assert Event.identifier('action_network:1efc3644-af25-4253-90b8-a0baf12dbd1e').exists

    assert_difference 'Event.count', 1 do
      Api::Events.import!
    end

    assert Event.where(name: 'March 14th Rally').exists
    assert Event.where(title: 'House Party for Progress').exists

    march_14_event = Event.where(name: 'March 14th Rally').first!

    assert_equal 'open', march_14_event.osdi_type

    expected_identifiers = [
      'action_network:d91b4b2e-ae0e-4cd3-9ed7-d0ec501b0bc3',
      'foreign_system:1',
      "advocacycommons:#{march_14_event.id}"
    ].sort
    assert_equal expected_identifiers, march_14_event.identifiers&.sort, 'identifiers'

    updated_event = Event.identifier('action_network:a3c724db-2799-49a6-970a-7c3c0844645d').first!
    assert_equal 'Teach in', updated_event.title, 'Should update title'
  end
end
