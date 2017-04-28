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

  test 'get #index with filter' do
    sign_in people(:one)
    get events_url(filter: Event.first.title.first(4)), as: :json
    assert_response :success
    json = JSON.parse(@response.body)
    assert_equal 1, json['data'].size
    assert_equal Event.first.id, json['data'].first['id'].to_i
  end
end
