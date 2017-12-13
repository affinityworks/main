require 'test_helper'
require 'minitest/mock'

class ImportsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test 'get #find' do
    person = Person.create(given_name: 'given_name', family_name: 'family_name')
    group = groups(:test)
    person.groups.push(group)
    EmailAddress.create(address: 'example@example.com', person: person)
    sign_in person
    url = 'https://www.facebook.com/123465'

    get find_group_imports_url(remote_event_url: url, group_id: group.id), as: :json
    assert_redirected_to group_events_url(group_id: group.id)

    person = people(:organizer)
    sign_in person

    remote_event = { 'name' => 'Name', 'start_time' => Date.today.to_s }
    facebook_agent = Minitest::Mock.new
    facebook_agent.expect :find, remote_event, [url]

    event = Event.create(start_date: Date.today, status: 'MyString')
    event.groups.push(group)

    Facebook::Event.stub :new, facebook_agent do
      get find_group_imports_url(group_id: group.id, remote_event_url: url), as: :json
      json = JSON.parse(@response.body)
      assert_equal 1, json['events']['data'].size
      assert_equal event.id, json['events']['data'].first['id'].to_i
      assert_equal remote_event['name'], json['remote_event']['name']
    end
  end

  test 'post #create when Event not found' do
    current_user = people(:organizer)
    group = current_user.groups.first
    sign_in current_user

    remote_event_count_before = RemoteEvent.count

    post group_imports_url(
      group_id: group.id,
      event_id: '',
      remote_event: {
        id: 'uid',
        name: 'facebook event'
      }
    ), as: :json

    assert_response :unprocessable_entity
    assert_equal remote_event_count_before, RemoteEvent.count
    assert_equal 'Event can\'t be blank', JSON.parse(@response.body)[0]
  end

  test 'post #create when missing id' do
    current_user = people(:organizer)
    group = current_user.groups.first
    sign_in current_user

    remote_event_count_before = RemoteEvent.count

    post group_imports_url(
      group_id: group.id,
      event_id: Event.first,
      remote_event: {
        id: '',
        name: 'facebook event'
      }
    ), as: :json

    assert_response :unprocessable_entity
    assert_equal remote_event_count_before, RemoteEvent.count
    assert_equal 'Uid can\'t be blank', JSON.parse(@response.body)[0]
  end

  test 'post #create' do
    current_user = people(:organizer)
    group = current_user.groups.first
    sign_in current_user

    remote_event_count_before = RemoteEvent.count
    facebook_event_count_before  = FacebookEvent.count

    post group_imports_url(
      group_id: group.id,
      event_id: Event.first,
      remote_event: {
        id: 'uid',
        name: 'facebook event'
      }
    ), as: :json

    assert_response :success
    assert_equal remote_event_count_before + 1, RemoteEvent.count
    assert_equal facebook_event_count_before + 1, FacebookEvent.count
  end

  test 'get #attendances' do
    current_user = people(:organizer)
    remote_event = remote_events(:facebook)
    group = current_user.groups.first
    sign_in current_user

    remote_attendances = [{ 'name' => 'Test Admin', 'id' => '12345' }]
    facebook_event_attendance = Minitest::Mock.new
    facebook_event_attendance.expect :attendances, remote_attendances

    Facebook::EventAttendance.stub :new, facebook_event_attendance do
      get attendances_group_imports_url(group_id: group.id, remote_event_id: remote_event.id), as: :json
      data = JSON.parse(@response.body)

      assert_response :success
      assert_equal 1, data.size
      assert_equal 'Test Admin', data.first['fb_rsvp']['name']
      assert_equal people(:admin).id , data.first['person']['data']['id'].to_i
    end
  end

  test 'post #create_facebook_attendance with existing attendance' do
    current_user = people(:organizer)
    remote_event = remote_events(:facebook)
    person = people(:member2)
    group = current_user.groups.first
    facebook_id = '1232345'
    person.memberships.create(:group => group, :role =>'member')
    sign_in current_user

    post create_attendance_group_imports_url(group_id: group.id, remote_event_id: remote_event.id,
      person_id: person.id, facebook_id: facebook_id
    )

    assert_response :success
    person.reload
    assert_equal "facebook:#{facebook_id}", person.identifier('facebook')
    assert_includes person.attendances.last.origins, Origin.facebook
  end

  test 'post #create_facebook_attendance without existing attendance' do
    current_user = people(:organizer)
    group = current_user.groups.first
    remote_event = remote_events(:facebook)
    person = Person.create(groups: current_user.groups, given_name: 'given_name', family_name: 'family_name')
    facebook_id = '1232345'
    sign_in current_user

    assert_difference 'person.attendances.count', 1 do
      post create_attendance_group_imports_url(
        group_id: group.id,
        remote_event_id: remote_event.id,
        person_id: person.id,
        facebook_id: facebook_id
      )
      person.reload
    end

    assert_response :success
    assert_equal "facebook:#{facebook_id}", person.identifier('facebook')
    assert_includes person.attendances.last.origins, Origin.facebook
  end

  test 'delete #delete_facebook_attendance with only origin' do
    current_user = people(:organizer)
    remote_event = remote_events(:facebook)
    group = current_user.groups.first
    person = people(:member2)
    facebook_id = '1232345'
    person.add_identifier('facebook', facebook_id)
    person.attendances.first.origins.push(Origin.facebook)
    person.memberships.create(:group => group, :role =>'member')
    person.save
    sign_in current_user

    assert_difference 'person.attendances.count', -1 do
      delete delete_attendance_group_imports_url(
        group_id: group.id,
        remote_event_id: remote_event.id,
        person_id: person.id
      )
      person.reload
    end

    assert_response :success
    assert_nil person.identifier('facebook')
  end

  test 'delete #delete_facebook_attendance with multiple origins' do
    current_user = people(:organizer)
    remote_event = remote_events(:facebook)
    group = current_user.groups.first
    person = people(:member2)
    facebook_id = '1232345'
    person.add_identifier('facebook', facebook_id)
    person.attendances.first.origins.push(Origin.facebook)
    person.attendances.first.origins.push(Origin.action_network)
    person.memberships.create(:group => group, :role =>'member')
    person.save
    sign_in current_user

    assert_difference 'person.attendances.count', 0 do
      delete delete_attendance_group_imports_url(
        group_id: group.id,
        remote_event_id: remote_event.id,
        person_id: person.id
      )
      person.reload
    end

    assert_response :success
    assert_nil person.identifier('facebook')
  end
end
