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

    event = Event.where(name: 'March 14th Rally').first!
    assert_equal 'open', event.osdi_type
  end
end
