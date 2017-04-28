require 'test_helper'

class Api::V1::AttendancesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test 'PUT #update' do
    Api::User.create!(osdi_api_token: 'CF32zTyg_KXFQbPzvoz3', name: 'API friend', email: 'api@example.com')

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

    new_attendance_status = nil
    set_attendance_status(event.id, attendance.id, new_attendance_status)

    attendance.reload
    assert_nil attendance.attended, 'Sets the attendance to nil.'
  end

  def set_attendance_status(event_id, attendance_id, status)
    put api_v1_event_attendance_url(event_id: event_id, id: attendance_id, params: { attended: status }),
      as: :json,
      headers: { 'OSDI-API-Token' => 'CF32zTyg_KXFQbPzvoz3', 'Content-Type' => 'application/json' }
  end
end
