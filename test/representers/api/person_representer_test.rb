require 'test_helper'

class Api::PersonRepresenterTest < ActiveSupport::TestCase
  test 'to_json' do
    person = Person.new(family_name: 'Simpson')

    json = JSON.parse(Api::PersonRepresenter.new(person).to_json)

    assert_equal 'Simpson', json['family_name'], 'family_name'
  end
end
