require 'test_helper'

class AttendancesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @event = events(:test)
  end

  test 'require authentication' do
    get event_attendances_url(event_id: @event.id), as: :json
    assert_response :unauthorized
  end

  test 'get #index' do
    attendance_1, attendance_2 = [attendances(:two), attendances(:two)]
    sign_in people(:organizer)
    get event_attendances_url(event_id: @event.id), as: :json
    assert_response :success
    json = JSON.parse(@response.body)
    assert_equal @event.attendances.count, json['attendances']['data'].size
    assert_equal @event.attendances.first.id, json['attendances']['data'].first['id'].to_i
  end

  test 'PUT #update' do
    sign_in people(:organizer)

    event = people(:organizer).events.first
    attendance = people(:organizer).attendances.first
    new_attendance_status = true

    assert_not attendance.attended

    set_attendance_status(event.id, attendance.id, new_attendance_status)

    attendance.reload
    assert attendance.attended, 'Sets the attendance to true.'

    new_attendance_status = false
    set_attendance_status(event.id, attendance.id, new_attendance_status)

    attendance.reload
    assert_not attendance.attended, 'Sets the attendance to true.'

    json = JSON.parse(response.body)['data']
    assert_equal json['attributes']['attended'], attendance.attended
    assert_equal json['attributes']['status'], attendance.status

    new_attendance_status = nil
    set_attendance_status(event.id, attendance.id, new_attendance_status)

    attendance.reload
    assert_nil attendance.attended, 'Sets the attendance to nil.'
  end

  test 'post #create when the attendee is already in the database' do
    event = events(:one)
    current_user = people(:one)
    sign_in current_user

    new_attendee = people(:two)
    new_attendee.memberships = []
    new_attendee.attendances = []
    new_attendee.save

    post event_attendances_url(
      event_id: event.id,
      params: {
        attendance: {
          primary_email_address: new_attendee.primary_email_address
        }
      }
    ), as: :json

    assert_response :success

    new_attendee.reload
    assert_equal 1, new_attendee.memberships.count, 'creates a new membership'
    assert_equal 1, new_attendee.attendances.count, 'creates a new attendance'
  end

  test 'post #create when the attendee is a new user' do
    event = events(:one)
    current_user = people(:one)
    sign_in current_user

    email = 'test@test.com'
    phone = rand(1_000_000).to_s

    assert_difference 'Person.count', 1 do
      post event_attendances_url(
      event_id: event.id,
      params: {
        attendance: {
          primary_email_address: email,
          primary_phone_number: phone,
          family_name: 'wayne',
          given_name: 'bruce',
          primary_personal_address: {
            postal_code: '54000',
            address_lines: ['123 Some Street'],
            locality: 'Some locality'
          }
        }
      }
      ), as: :json
    end

    assert_response :success

    new_attendee = Person.last
    assert_equal 1, new_attendee.groups.count
    assert_equal 1, new_attendee.events.count
    assert_equal new_attendee.primary_email_address, email
    assert_equal new_attendee.primary_phone_number, phone
    assert_equal new_attendee.primary_personal_address.postal_code, '54000'
    assert_equal new_attendee.primary_personal_address.address_lines, ['123 Some Street']
    assert_equal new_attendee.primary_personal_address.locality, 'Some locality'
    assert new_attendee.primary_personal_address.primary
  end

  def set_attendance_status(event_id, attendance_id, status)
    put event_attendance_url(event_id: event_id, id: attendance_id, params: { attended: status }),
      as: :json
    end
end
