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

    stub_request(
      :post, url(event.attendance_event.identifier_id('action_network'))
    ).to_return(status: 200)

    stub_request(
      :post, url(event.no_attendance_event.identifier_id('action_network'))
    ).to_return(status: 200)

    set_attendance_status(event, attendance.id, new_attendance_status)
    assert_response :unauthorized

    token = Minitest::Mock.new
    token.expect(:acceptable?, true, [Doorkeeper::OAuth::Scopes])
    token.expect(:acceptable?, true, [Doorkeeper::OAuth::Scopes])
    token.expect(:acceptable?, true, [Doorkeeper::OAuth::Scopes])

    @controller.stub(:doorkeeper_token, token) do

      set_attendance_status(event, attendance.id, new_attendance_status)
      assert_response :success

      attendance.reload
      assert attendance.attended, 'Sets the attendance to true.'

      new_attendance_status = false
      set_attendance_status(event, attendance.id, new_attendance_status)

      attendance.reload
      assert_not attendance.attended, 'Sets the attendance to true.'

      json = JSON.parse(response.body)['data']
      assert_equal json['attributes']['attended'], attendance.attended
      assert_equal json['attributes']['status'], attendance.status

      new_attendance_status = nil
      set_attendance_status(event, attendance.id, new_attendance_status)

      attendance.reload
      assert_nil attendance.attended, 'Sets the attendance to nil.'
    end
  end

  def set_attendance_status(event, attendance_id, status)
    put(:update, params: { event_id: event.id, id: attendance_id, attended: status })
  end

  def url(event_id)
    "https://actionnetwork.org/api/v2/events/#{event_id}/attendances"
  end
end
