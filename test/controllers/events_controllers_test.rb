require 'test_helper'

class EventsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test 'require authentication' do
    get events_url, as: :json
    assert_response :unauthorized
  end

  test 'get #index' do
    sign_in people(:one)
    get events_url, as: :json
    assert_response :success
    json = JSON.parse(@response.body)
    assert_equal 2, json['data'].size
  end
end
