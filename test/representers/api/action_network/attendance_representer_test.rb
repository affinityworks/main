require 'test_helper'

class Api::ActionNetwork::AttendanceRepresenterTest < ActiveSupport::TestCase
  test '#from_json links' do
    attendance = Attendance.new
    json = '{"action_network:person_id": "ceef7e23-4617-4af8-bd0f-60029299d8cd", "action_network:event_id": "1efc3644-af25-4253-90b8-a0baf12dbd1e"}'
    Api::ActionNetwork::AttendanceRepresenter.new(attendance).from_json(json)
    assert_equal '1efc3644-af25-4253-90b8-a0baf12dbd1e', attendance.event_uuid
    assert_equal 'ceef7e23-4617-4af8-bd0f-60029299d8cd', attendance.person_uuid
  end
end
