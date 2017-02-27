require 'test_helper'

class Api::EventsRepresenterTest < ActiveSupport::TestCase
  test 'from_json' do
    events = Api::Events.new
    Api::EventsRepresenter.new(events).from_json('{"_embedded": {"osdi:events": [{"name":"Womens March PDX"}]}}')
    assert_equal 'Womens March PDX', events.events.first.name
  end
end
