require 'test_helper'

class Api::ActionNetwork::PeopleRepresenterTest < ActiveSupport::TestCase
  test '#from_json' do
    collection = Api::Collections::People.new
    Api::Collections::PeopleRepresenter.new(collection).from_json(
      '{"page": 2, "_embedded": {"osdi:people": [{"family_name":"Smithers"}]}}'
    )
    assert_equal 2, collection.page
    assert_equal 1, collection.people.size
    assert_equal 'Smithers', collection.people.first.family_name
  end

  test '#to_json' do
    collection = Api::Collections::People.new(Person.page(0))
    request = ActionDispatch::Request.new({})
    raw_json = Api::Collections::PeopleRepresenter.new(collection, request).to_json
    json = JSON.parse(raw_json)
    assert_equal 1, json['page']
    assert_equal 2, json['_embedded']['osdi:people'].size
  end
end
