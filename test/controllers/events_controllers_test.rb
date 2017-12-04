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
    affiliate_event = Event.create(title: 'title', origin_system: 'Affinity')
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
    group.events.update(start_date: Time.now - 1.day)

    sign_in organizer
    filter = { filter: { name: organizer.events.first.title.first(4),
                         start_date: Date.today - 10.day, end_date: Date.today  } }
    get group_events_url(group_id: group.id), params: filter, as: :json
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

  test 'post #create with valid data' do
    person = people(:organizer)
    group_id = groups(:test).id
    sign_in person

    location_attributes = { address_lines: ['asdas'], locality: 'asd', venue: 'asdasd',
                            postal_code: '1245', region: 'asd' }
    event_attributes = { event: { title: 'asdasd', start_date: '2017-12-31T09:10:20.000Z',
                                  origin_system: 'Affinity', description: 'description',
                                  location_attributes: location_attributes },
                         group_id: '1'}


    assert_difference 'Event.count', 1 do
      assert_difference 'Address.count', 1 do
        post group_events_url(group_id), params:  event_attributes, as: :json
      end
    end

    assert_response :success
  end

  test 'post #create with invalid data' do
    person = people(:organizer)
    group_id = groups(:test).id
    sign_in person

    location_attributes = { address_lines: ['asdas'], locality: 'asd', venue: 'asdasd',
                            postal_code: '1245', region: 'asd' }
    event_attributes = { event: { start_date: '2017-12-31T09:10:20.000Z',
                                  location_attributes: location_attributes },
                         group_id: '1'}


    assert_difference 'Event.count', 0 do
      assert_difference 'Address.count', 0 do
        post group_events_url(group_id), params:  event_attributes, as: :json
      end
    end

    assert_response :unprocessable_entity
  end

end
