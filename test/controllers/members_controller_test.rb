require 'test_helper'

class MembersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test 'get #index' do
    person = people(:organizer)
    sign_in person

    get members_url, as: :json
    assert_response :success
    json = JSON.parse(response.body)
    assert_equal 4, json['members']['data'].count
    assert_equal person.groups.first.members.first.id, json['members']['data'].first['id'].to_i
  end

  test 'members shouldnt be able to see list' do
    person = people(:member1)
    sign_in person
    get members_url, as: :json
    assert_response 302
  end


end
