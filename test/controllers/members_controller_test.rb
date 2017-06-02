require 'test_helper'

class MembersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test 'get #index' do
    person = people(:organizer)
    sign_in person

    get members_url, as: :json
    assert_response :success
    json = JSON.parse(response.body)
    assert_equal person.groups.first.members.count, json['members']['data'].count
    response_members_ids = json['members']['data'].map { |m| m['id'].to_i }
    assert_includes response_members_ids, person.groups.first.members.first.id
  end

  test 'members shouldnt be able to see list' do
    person = people(:member1)
    sign_in person
    get members_url, as: :json
    assert_response 302
  end
end
