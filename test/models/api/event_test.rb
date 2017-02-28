require 'test_helper'

class Api::EventTest < ActiveSupport::TestCase
  test '.import!' do
    stub_request(:get, 'https://actionnetwork.org/api/v2/events')
      .with(headers: { 'OSDI-API-TOKEN' => 'test-token' })
      .to_return(body: File.read("#{Rails.root}/test/fixtures/files/events.json"))

    assert_difference 'Event.count', 2 do
      Event.import!
    end

    assert Event.where(name: 'March 14th Rally').exists
    assert Event.where(title: 'House Party for Progress').exists

    march_14_event = Event.where(name: 'March 14th Rally').first!

    assert_equal 'open', march_14_event.osdi_type

    expected_identifiers = [
      'osdi_sample_system:d91b4b2e-ae0e-4cd3-9ed7-d0ec501b0bc3',
      'foreign_system:1',
      "advocacycommons-#{march_14_event.id}"
    ].sort
    assert_equal expected_identifiers, march_14_event.identifiers&.sort, 'identifiers'
  end
end
