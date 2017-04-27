require 'test_helper'

class AttendancesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @event = events(:one)
  end

  test 'require authentication' do
    get event_attendances_url(event_id: @event.id), as: :json
    assert_response :unauthorized
  end

  test 'get #index' do
    attendance_1, attendance_2 = [attendances(:one), attendances(:one)]
    sign_in people(:one)
    get event_attendances_url(event_id: @event.id), as: :json
    assert_response :success
    json = JSON.parse(@response.body)
    assert_equal 2, json['data'].size
  end

  test 'PUT #update' do
    sign_in people(:one)

    event = Event.first
    attendance = Attendance.first
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
  end

  def set_attendance_status(event_id, attendance_id, status)
    put event_attendance_url(event_id: event_id, id: attendance_id, params: { attended: status }),
      as: :json
    end
end
