require 'test_helper'

class Api::ActionNetwork::PeopleRepresenterTest < ActiveSupport::TestCase
  test '#from_json' do
    collection = Api::Collections::People.new
    Api::Collections::PeopleRepresenter.new(collection).from_json(
      '{"page": 2, "_embedded": {"osdi:people": [{"family_name":"Smithers"}]}, "total_records": 12}'
    )
    assert_equal 2, collection.page
    assert_equal 12, collection.total_records
    assert_equal 1, collection.people.size
    assert_equal 'Smithers', collection.people.first.family_name
  end

  test 'next link' do
    collection = Api::Collections::People.new
    representer = Api::Collections::PeopleRepresenter.new(collection)
    representer.from_json(
      '{"_links": {"next": {"href": "https://actionnetwork.org/api/v2/people?page=2"}}, "total_records": 99, "page": 4}'
    )
    assert_equal 'https://actionnetwork.org/api/v2/people?page=2', representer.links['next'].href
    assert_equal 4, collection.page
    assert_equal 99, collection.total_records
  end

  test '#to_json' do
    collection = Api::Collections::People.new(Person.page(0))
    request = ActionDispatch::Request.new({})
    raw_json = Api::Collections::PeopleRepresenter.new(collection, request).to_json
    json = JSON.parse(raw_json)
    assert_equal 1, json['page']
    assert_equal Person.count, json['_embedded']['osdi:people'].size
  end
end
