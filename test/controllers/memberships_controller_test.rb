require 'test_helper'

class MembershipsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test 'get #index' do
    person = people(:two)
    group = groups(:two)
    sign_in person

    affiliate = Group.create(an_api_key: rand(1_000_000).to_s)
    membership = Person.create(given_name: 'given_name', family_name: 'family_name')
    affiliate_membership = Membership.create(person: membership)
    affiliate.memberships.push(affiliate_membership)
    Affiliation.create(affiliated: affiliate, group: group)

    get group_memberships_url(group_id: group.id), as: :json
    assert_response :success
    json = JSON.parse(response.body)

    response_members_ids = json['memberships']['data'].map { |m| m['id'].to_i }
    assert_includes response_members_ids, group.memberships.first.id
    assert_includes response_members_ids, affiliate_membership.id

    assert_equal  group.memberships.count + affiliate.memberships.count,
    json['memberships']['data'].count

  end

  test 'get #index with filter' do
    person = people(:organizer)
    sign_in person

    get group_memberships_url(group_id: groups(:test).id, filter: 'test admin'), as: :json
    assert_response :success
    json = JSON.parse(response.body)

    assert_equal 1, json['memberships']['data'].count
    assert_equal people(:admin).memberships.first.id, json['memberships']['data'].first['id'].to_i
  end

  test 'get #show' do
    person = people(:organizer)
    sign_in person

    get group_membership_url(group_id: groups(:test).id, id: person.id), as: :json
    assert_response :success
  end


#  skip 'get #show no group' do
#    person = people(:organizer)
#    sign_in person
#
#    get membership_url( id: person.id), as: :json
#    assert_response :success
#  end

  test 'get #show on affiliated' do
    person = people(:organizer)
    sign_in person
    affiliate = Group.create(an_api_key: rand(1_000_000).to_s)
    affiliate_membership = Membership.create(person: person, group: affiliate)
    Affiliation.create(affiliated: affiliate, group: groups(:test))

    get group_membership_url(group_id: groups(:test).id, id: person.id), as: :json
    assert_response :success

    get group_membership_url(group_id: affiliate.id, id: person.id), as: :json
    assert_response :success
  end

  test 'get #show on nested affiliated' do
    person = people(:national_organizer)
    sign_in person
    
    city_person = Person.create(:given_name => "City", :family_name => "Dweller")

    affiliate_membership = Membership.create(person: Person.create, group: groups(:city))

    get group_membership_url(group_id: groups(:city).id, id: city_person.id), as: :json
    assert_response :success
  end
 

  test 'update_role' do
    person = people(:member2)
    group = groups(:two)
    sign_in person
    membership = memberships(:member2)

    if membership.role == "member"
      membership.update(role: 1)
    else
      membership.update(role: 0)
    end
    assert people(:organizer)
  end


end
