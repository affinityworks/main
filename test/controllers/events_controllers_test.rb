require 'test_helper'

class EventsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test 'require authentication' do
    get events_url, as: :json
    assert_response :unauthorized
  end

  test 'get #index' do
    person = people(:one)
    group = person.groups.first
    sign_in person

    get events_url, as: :json
    assert_response :success
    json = JSON.parse(@response.body)
    assert_equal group.events.count, json['events']['data'].size
  end

  test 'get #index with filter' do
    sign_in people(:one)
    get events_url(filter: Event.first.title.first(4)), as: :json
    assert_response :success
    json = JSON.parse(@response.body)
    assert_equal 1, json['events']['data'].size
    assert_equal Event.first.id, json['events']['data'].first['id'].to_i
  end

  test 'get #show' do
    sign_in people(:one)
    event = Event.first
    get event_url(id: event.id), as: :json
    assert_response :success
    json = JSON.parse(@response.body)
    assert_equal event.name, json['data']['attributes']['name']
  end

end
