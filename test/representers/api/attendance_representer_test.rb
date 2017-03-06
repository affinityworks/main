require 'test_helper'

class Api::AttendanceRepresenterTest < ActiveSupport::TestCase
  test '#from_json' do
    attendance = Attendance.new
    Api::AttendanceRepresenter.new(attendance).from_json('{"status": "accepted"}')
    assert_equal 'accepted', attendance.status
  end

  test '#from_json links' do
    attendance = Attendance.new
    json = '{"action_network:person_id": "ceef7e23-4617-4af8-bd0f-60029299d8cd"}'
    Api::AttendanceRepresenter.new(attendance).from_json(json)
  end

  test '#to_json links' do
    attendance = Attendance.new(id: 31, event_id: 19, person_id: 53)

    json = JSON.parse(Api::AttendanceRepresenter.new(attendance).to_json)

    assert_equal '/api/v1/attendances/31', json['_links']['self']['href'], '_links self'
  end
end
