require 'test_helper'

class EventsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test 'require authentication' do
    group = groups(:one)
    get group_events_url(group.id), as: :json
    assert_response :unauthorized
  end

  test 'get #index' do
    person = people(:organizer)
    group = person.groups.first
    sign_in person

    affiliate = Group.create(an_api_key: rand(1_000_000).to_s)
    affiliate_event = Event.create
    affiliate.events.push(affiliate_event)
    Affiliation.create(affiliated: affiliate, group: group)

    get group_events_url(group.id), as: :json
    assert_response :success
    json = JSON.parse(@response.body)
    assert_equal group.events.count + affiliate.events.count, json['events']['data'].size
  end

  test 'get #index with filter' do
    organizer = people(:organizer)
    group = organizer.groups.first
    sign_in organizer

    get group_events_url(group_id: group.id, filter: organizer.events.first.title.first(4)), as: :json
    assert_response :success
    json = JSON.parse(@response.body)
    assert_equal 1, json['events']['data'].size
    assert_equal organizer.groups.first.events.first.id, json['events']['data'].first['id'].to_i
  end

  test 'get #show' do
    organizer = people(:organizer)
    sign_in organizer
    event = events(:test)
    group = organizer.groups.first

    get group_event_url(group_id: group.id, id: event.id), as: :json
    assert_response :success
    json = JSON.parse(@response.body)
    assert_equal event.name, json['data']['attributes']['name']
  end

end
