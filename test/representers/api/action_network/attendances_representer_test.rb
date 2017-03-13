require 'test_helper'

class Api::AttendancesRepresenterTest < ActiveSupport::TestCase
  test 'from_json' do
    attendances = Api::Collections::Attendances.new
    Api::ActionNetwork::AttendancesRepresenter.new(attendances).from_json(
      '{"_embedded": {"osdi:attendances": [{"status":"declined", "action_network:person_id": "1337"}]}}'
    )
    assert_equal 1, attendances.attendances.size
    assert_equal 'declined', attendances.attendances.first.status
    assert_equal '1337', attendances.attendances.first.person_uuid
  end
end
