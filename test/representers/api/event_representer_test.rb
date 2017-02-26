require 'test_helper'

class Api::EventRepresenterTest < ActiveSupport::TestCase
  test 'from_json' do
    event = Event.new
    EventRepresenter.new(event).from_json('{"name":"Womens March PDX"}')
    assert_equal 'Womens March PDX', event.name
  end
end
