require 'test_helper'

class Api::ActionNetwork::PeopleTest < ActiveSupport::TestCase
  test '.import!' do
    group = groups(:one)

    person_not_from_action_network = group.members.create!(updated_at: Time.zone.local(2016))

    unchanged_person = group.members.create!(
      identifiers: ['action_network:d91b4b2e-ae0e-4cd3-9ed7-d0ec501b0bc3'],
      given_name: 'John',
      family_name: 'Smith',
      updated_at: Time.utc(2014, 2, 20, 21, 16, 57)
    )

    person_with_updates = group.members.create!(
      identifiers: ['action_network:d32fcdd6-7366-466d-a3b8-7e0d87c3cd8b'],
      given_name: 'Mayor',
      family_name: 'Quimby',
      updated_at: Time.utc(2012)
    )

    stub_request(:get, 'https://actionnetwork.org/api/v2/people')
      .with(headers: { 'OSDI-API-TOKEN' => group.an_api_key })
      .to_return(body: File.read(Rails.root.join('test', 'fixtures', 'files', 'people.json')))

    stub_request(:get, 'https://actionnetwork.org/api/v2/people?page=2')
      .with(headers: { 'OSDI-API-TOKEN' => group.an_api_key })
      .to_return(body: File.read(Rails.root.join('test', 'fixtures', 'files', 'people_page_2.json')))

    stub_request(:get, "https://actionnetwork.org/api/v2/people").
      with(:headers => {'Accept'=>'application/json', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Type'=>'application/json', 'Osdi-Api-Token'=>'c96dc7a808ed80fca8bb4953f8ac10bf', 'User-Agent'=>'Ruby'}).
      to_return(body: File.read(Rails.root.join('test', 'fixtures', 'files', 'people.json')))

    stub_request(:get, "https://actionnetwork.org/api/v2/people?page=2").
      with(:headers => {'Accept'=>'application/json', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Type'=>'application/json', 'Osdi-Api-Token'=>'c96dc7a808ed80fca8bb4953f8ac10bf', 'User-Agent'=>'Ruby'}).
      to_return(body: File.read(Rails.root.join('test', 'fixtures', 'files', 'people_page_2.json')))

    assert_difference 'Person.count', 2 do
      Api::ActionNetwork::People.import!(group)
    end

    assert_equal Time.zone.local(2016), person_not_from_action_network.reload.updated_at

    new_person = group.members.any_identifier('action_network:1efc3644-af25-4253-90b8-a0baf12dbd1e').first!
    assert_equal 'Jane', new_person.given_name
    assert_equal 'Doe', new_person.family_name
    assert_equal Time.utc(2014, 2, 20, 21, 16, 56), new_person.updated_at, 'Use Action Network updated time, not current time'
    assert new_person.memberships.last.member?, 'Person membeship should be member'
    assert group.members.include?( new_person )#, "person should have membership in the group"


    # Originally imported from AN and there are no updates: should not change
    assert group.members.any_identifier('action_network:d91b4b2e-ae0e-4cd3-9ed7-d0ec501b0bc3').exists
    unchanged_person.reload
    assert_equal Time.utc(2014, 2, 20, 21, 16, 57), unchanged_person.updated_at
    assert_equal 'John', unchanged_person.given_name
    assert_equal 'Smith', unchanged_person.family_name
    assert unchanged_person.memberships.last.member?, 'Person membeship should be member'
    assert group.members.include?( unchanged_person )#, "person should have membership in the group"

    # Originally imported from AN; should apply updates
    person_with_updates.reload
    assert_equal Time.utc(2014, 12, 31), person_with_updates.updated_at
    assert_equal "Joseph Fitzgerald O'Malley", person_with_updates.given_name
    assert_equal 'Quimby', person_with_updates.family_name
    assert person_with_updates.memberships.last.member?, 'Person membeship should be member'
    assert group.members.include? person_with_updates#, "person should have membership in the group"

    # From page 2
    assert group.members.any_identifier('action_network:65345d7d-cd24-466a-a698-4a7686ef684f').exists?, 'Page through import response'

    another_group = groups(:fourth)

    assert_not another_group.members.any_identifier('action_network:1efc3644-af25-4253-90b8-a0baf12dbd1e').any?
    assert_not another_group.members.any_identifier('action_network:d91b4b2e-ae0e-4cd3-9ed7-d0ec501b0bc3').any?

    stub_request(:get, 'https://actionnetwork.org/api/v2/people')
      .with(headers: { 'OSDI-API-TOKEN' => another_group.an_api_key })
      .to_return(body: File.read(Rails.root.join('test', 'fixtures', 'files', 'people.json')))

    stub_request(:get, 'https://actionnetwork.org/api/v2/people?page=2')
      .with(headers: { 'OSDI-API-TOKEN' => another_group.an_api_key })
      .to_return(body: File.read(Rails.root.join('test', 'fixtures', 'files', 'people_page_2.json')))

    stub_request(:get, "https://actionnetwork.org/api/v2/people").
      with(:headers => {'Accept'=>'application/json', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Type'=>'application/json', 'Osdi-Api-Token'=> another_group.an_api_key, 'User-Agent'=>'Ruby'}).
      to_return(body: File.read(Rails.root.join('test', 'fixtures', 'files', 'people.json')))

    assert_difference 'Person.count', 0 do
      Api::ActionNetwork::People.import!(another_group)
    end

    assert another_group.members.any_identifier('action_network:1efc3644-af25-4253-90b8-a0baf12dbd1e').exists?, "confirm the alredy imported user gets added to the new group"
    assert another_group.members.any_identifier('action_network:d91b4b2e-ae0e-4cd3-9ed7-d0ec501b0bc3').exists?, "confirm the alredy imported user gets added to the new group"



  end
end
