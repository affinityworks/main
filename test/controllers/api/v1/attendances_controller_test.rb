require 'test_helper'
require 'minitest/mock'

class Api::V1::AttendancesControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers

  test 'PUT #update' do
    sign_in people(:one)

    event = Event.first
    attendance = Attendance.first
    new_attendance_status = true

    assert_not attendance.attended

    set_attendance_status(event.id, attendance.id, new_attendance_status)
    assert_response :unauthorized

    token = Minitest::Mock.new
    token.expect(:acceptable?, true, [Doorkeeper::OAuth::Scopes])
    token.expect(:acceptable?, true, [Doorkeeper::OAuth::Scopes])
    token.expect(:acceptable?, true, [Doorkeeper::OAuth::Scopes])

    @controller.stub(:doorkeeper_token, token) do

      set_attendance_status(event.id, attendance.id, new_attendance_status)
      assert_response :success

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
  end

  def set_attendance_status(event_id, attendance_id, status)
    put(:update, params: { event_id: event_id, id: attendance_id, attended: status })
  end
end
