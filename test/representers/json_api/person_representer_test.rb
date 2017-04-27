require 'test_helper'

class JsonApi::PersonRepresenterTest < ActiveSupport::TestCase
  test 'to_json' do
    JSON.parse(JsonApi::PersonRepresenter.new(Person.new).to_json)
  end
end
