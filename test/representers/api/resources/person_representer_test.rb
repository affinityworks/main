require 'test_helper'

class Api::Resources::PersonRepresenterTest < ActiveSupport::TestCase
  test 'to_json' do
    person = Person.new(family_name: 'Simpson', id: 17, identifiers: ['advocacycommons:17'])

    json = JSON.parse(Api::Resources::PersonRepresenter.new(person).to_json)

    assert_equal 'Simpson', json['family_name'], 'family_name'
    assert_equal ['advocacycommons:17'], json['identifiers'], 'identifiers'
  end

  test 'custom_fields' do
    person = Person.create!(
      custom_fields: { foo: 'bar', baz: 'bat' },
      email: 'person@example.com',
      password: 'secret'
    )

    json = JSON.parse(Api::Resources::PersonRepresenter.new(person).to_json)

    assert_equal 'bar', json['custom_fields']['foo'], 'custom_fields foo'
    assert_equal 'bat', json['custom_fields']['baz'], 'custom_fields baz'
  end

  test 'links' do
    person = Person.new(id: 39)

    json = JSON.parse(Api::Resources::PersonRepresenter.new(person).to_json)

    assert_equal '/api/v1/people/39', json['_links']['self']['href'], '_links self'
  end
end
