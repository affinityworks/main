require 'test_helper'

class TicketTest < ActiveSupport::TestCase
  test "basic associations" do
    one = tickets(:one)
    assert_kind_of Attendance, one.attendance
  end

end
