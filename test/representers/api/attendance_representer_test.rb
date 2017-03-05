require 'test_helper'

class Api::AttendanceRepresenterTest < ActiveSupport::TestCase
  test 'from_json' do
    attendance = Attendance.new
    Api::AttendanceRepresenter.new(attendance).from_json('{"status": "accepted"}')
    assert_equal 'accepted', attendance.status
  end
end
