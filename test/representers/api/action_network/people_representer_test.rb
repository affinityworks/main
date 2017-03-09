require 'test_helper'

class Api::ActionNetwork::PeopleRepresenterTest < ActiveSupport::TestCase
  test '#from_json' do
    payload = Api::ActionNetwork::People.new
    people = Api::Collections::PeopleRepresenter.new(payload).from_json(
      '{"page": 2, "_embedded": {"osdi:people": [{"email":"person@example.com"}]}}'
    )
    assert_equal 2, people.current_page
  end

  test '#to_json' do
    payload = Person.page(0)
    request = ActionDispatch::Request.new({})
    raw_json = Api::Collections::PeopleRepresenter.new(payload, request).to_json
    json = JSON.parse(raw_json)
    assert_equal 1, json['page']
  end
end
