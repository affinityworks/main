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
    assert_equal group.events.count, json['data'].size
  end

  test 'get #index without group' do
    person = people(:one)
    person.groups = []
    person.save

    sign_in people(:one)
    get events_url, as: :json
    assert_response :success
  end

  test 'get #index with filter' do
    sign_in people(:one)
    get events_url(filter: Event.first.title.first(4)), as: :json
    assert_response :success
    json = JSON.parse(@response.body)
    assert_equal 1, json['data'].size
    assert_equal Event.first.id, json['data'].first['id'].to_i
  end

  test 'get #index using osdi token' do
    get events_url, headers: { 'OSDI-API-Token': 'CF32zTyg_KXFQbPzvoz3' }, as: :json
    assert_response :success
    json = JSON.parse(@response.body)
    assert_equal 1, json['data'].size
    assert_equal Event.first.id, json['data'].first['id'].to_i
  end

  test 'get #show 1' do
    sign_in people(:one)
    get events_url(events(:one)), as: :json
    assert_response :success
    json = JSON.parse(@response.body)
    assert_equal events(:one).name, json['data'].name
  end

  test 'get #show 1 with token' do
    get event_url(events(:one)), headers: { 'OSDI-API-Token': 'CF32zTyg_KXFQbPzvoz3' }, as: :json
    assert_response :success
    json = JSON.parse(@response.body)
    assert_equal events(:one).name, json['data'].name
  end

end
