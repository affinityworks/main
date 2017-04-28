require 'test_helper'

class JsonApi::EventsRepresenterTest < ActiveSupport::TestCase
  test 'to_json' do
    JSON.parse(JsonApi::EventsRepresenter.for_collection.new(Event.all).to_json)
  end
end
