require 'test_helper'

class MembersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test 'get #index' do
    person = Person.first
    sign_in person

    get members_url, as: :json
    assert_response :success
    json = JSON.parse(response.body)
    assert_equal 1, json['members']['data'].count
    assert_equal Person.first.id, json['members']['data'].first['id'].to_i
  end
end
