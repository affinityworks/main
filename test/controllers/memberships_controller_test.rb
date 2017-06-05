require 'test_helper'

class MembershipsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test 'get #index' do
    person = people(:organizer)
    sign_in person

    get memberships_url, as: :json
    assert_response :success
    json = JSON.parse(response.body)

    assert_equal person.groups.first.members.count, json['memberships']['data'].count
    response_members_ids = json['memberships']['data'].map { |m| m['id'].to_i }
    assert_includes response_members_ids, person.groups.first.memberships.first.id
  end

  test 'get #index with filter' do
    person = people(:organizer)
    sign_in person

    get memberships_url(filter: 'admin'), as: :json
    assert_response :success
    json = JSON.parse(response.body)

    assert_equal 1, json['memberships']['data'].count
    assert_equal people(:admin).memberships.first.id, json['memberships']['data'].first['id'].to_i
  end
end
