require 'test_helper'

class Api::AttendancesRepresenterTest < ActiveSupport::TestCase
  test 'from_json' do
    attendances = Api::ActionNetwork::Attendances.new
    Api::ActionNetwork::AttendancesRepresenter.new(attendances).from_json(
      '{"_embedded": {"osdi:attendances": [{"status":"declined"}]}}'
    )
    assert_equal 1, attendances.attendances.size
    assert_equal 'declined', attendances.attendances.first.status
  end
end
