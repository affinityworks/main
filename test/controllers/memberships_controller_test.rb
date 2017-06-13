require 'test_helper'

class MembershipsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test 'get #index' do
    person = people(:organizer)
    group = person.groups.first
    sign_in person

    affiliate = Group.create(an_api_key: rand(1_000_000).to_s)
    affiliate_membership = Membership.create(person: Person.create)
    affiliate.memberships.push(affiliate_membership)
    Affiliation.create(affiliated: affiliate, group: group)

    get group_memberships_url(group_id: group.id), as: :json
    assert_response :success
    json = JSON.parse(response.body)

    assert_equal  group.memberships.count + affiliate.memberships.count,
                  json['memberships']['data'].count

    response_members_ids = json['memberships']['data'].map { |m| m['id'].to_i }
    assert_includes response_members_ids, group.memberships.first.id
    assert_includes response_members_ids, affiliate_membership.id
  end

  test 'get #index with filter' do
    person = people(:organizer)
    sign_in person

    get group_memberships_url(group_id: groups(:test).id, filter: 'admin'), as: :json
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
end
