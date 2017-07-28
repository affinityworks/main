require 'test_helper'

class MembersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test 'get #index' do
    person = people(:organizer)
    group = person.groups.first
    sign_in person

    affiliate = Group.create(an_api_key: rand(1_000_000).to_s)
    affiliate_member = Person.create
    affiliate.members.push(affiliate_member)
    Affiliation.create(affiliated: affiliate, group: group)

    get group_members_url(group_id: group.id), as: :json
    assert_response :success
    json = JSON.parse(response.body)
    assert_equal group.members.count + affiliate.members.count, json['members']['data'].count
    response_members_ids = json['members']['data'].map { |m| m['id'].to_i }
    assert_includes response_members_ids, person.groups.first.members.first.id
    assert_includes response_members_ids, affiliate_member.id
  end

# having issues with posting params for this 
#No route matches {:action=>"new", :controller=>"members"} missing required keys: [:group_id]

  test 'create member' do
    person = people(:organizer)
    group_id = groups(:test).id
    sign_in person
    get new_group_member_url
    assert_response :success

    assert_difference -> { Member.count } do
      post group_members_path(group_id), @response.params[{ person: { person: { given_name: "Test", family_name: "TestFamily", gender: "", gender_identity: "", party_identification: "", ethnicities: "", languages_spoken: "", birthdate: "", employer: ""}, email_address: {email_address: "yes@email.com"}, phone_number: {phone_number: "555-555-5555"}}, group_id: group_id }], as: :json
    end
    assert_response :success
  end 

  test 'members shouldnt be able to see list' do
    person = people(:member1)
    sign_in person
    get group_members_url(group_id: person.groups.first.id), as: :json
    assert_response 403
  end

  test 'get #attendances' do
    person = people(:organizer)
    sign_in person

    get attendances_group_member_url(group_id: person.groups.first.id, id: person.id), as: :json
    assert_response :success
  end
end
