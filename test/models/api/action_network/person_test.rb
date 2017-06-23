require 'test_helper'

class Api::ActionNetwork::PersonTest < ActiveSupport::TestCase
  test '.import!' do
    group = Group.first
    person_uuid = '06d13a33-6824-493b-a922-95e793f269d3'

    stub_request(:get, "https://actionnetwork.org/api/v2/people/#{person_uuid}")
      .with(:headers => {'Accept'=>'application/json', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Type'=>'application/json', 'Osdi-Api-Token'=>'test-token', 'User-Agent'=>'Ruby'})
      .to_return(body: File.read(Rails.root.join('test', 'fixtures', 'files', 'person.json')))

    assert_difference 'group.members.count', 1, 'Creates a new person.' do
      Api::ActionNetwork::Person.import!(person_uuid, group)
    end

    assert_no_difference 'group.members.count', 'Does not create already created people.' do
      Api::ActionNetwork::Person.import!(person_uuid, group)
    end
  end

  test 'duplicate import merge correctly' do

    person = Person.create(
      email_addresses: [
        EmailAddress.new(primary: true, address: 'evan@henshaw-plath.com'),
      ],
      password: "password"
    )
    encypted_password = person.encrypted_password
   
    group = Group.first
    group.members << person
    person1_uuid = '06d13a33-6824-493b-a922-95e793f269d3'
    person2_uuid = '06d13a33-6824-413b-a922-95e793f269d3'

    stub_request(:get, "https://actionnetwork.org/api/v2/people/#{person1_uuid}")
      .with(:headers => {'Accept'=>'application/json', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Type'=>'application/json', 'Osdi-Api-Token'=>'test-token', 'User-Agent'=>'Ruby'})
      .to_return(body: File.read(Rails.root.join('test', 'fixtures', 'files', 'person.json')))

    stub_request(:get, "https://actionnetwork.org/api/v2/people/#{person2_uuid}")
      .with(:headers => {'Accept'=>'application/json', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Type'=>'application/json', 'Osdi-Api-Token'=>'test-token', 'User-Agent'=>'Ruby'})
      .to_return(body: File.read(Rails.root.join('test', 'fixtures', 'files', 'person2.json')))


    assert_nothing_raised do
      Api::ActionNetwork::Person.import!(person1_uuid, group)
    end

    person.reload
    assert_equal 'Henshaw', person.family_name
    assert_equal person1_uuid, person.identifier_id('action_network')

    assert_equal encypted_password, person.encrypted_password

    assert_nothing_raised do
      Api::ActionNetwork::Person.import!(person2_uuid, group)
    end

    person.reload
    assert_equal 'Plath', person.family_name
    assert_equal person2_uuid, person.identifier_id('action_network')
  end

  test 'when the person is member of another group' do
    person = Person.create(
      email_addresses: [
        EmailAddress.new(primary: true, address: 'evan@henshaw-plath.com'),
      ]
    )

    group = Group.first
    group.members << person

    other_group = Group.last

    person_uuid = '06d13a33-6824-493b-a922-95e793f269d3'

    stub_request(:get, "https://actionnetwork.org/api/v2/people/#{person_uuid}")
      .with(:headers => {'Accept'=>'application/json', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Type'=>'application/json', 'Osdi-Api-Token'=>other_group.an_api_key, 'User-Agent'=>'Ruby'})
      .to_return(body: File.read(Rails.root.join('test', 'fixtures', 'files', 'person.json')))

    Api::ActionNetwork::Person.import!(person_uuid, other_group)

    person.reload
    assert_includes person.groups, group, 'keeps the old group'
    assert_includes person.groups, other_group, 'adds the new group'
  end
  


end
