require 'test_helper'

class AttendanceTest < ActiveSupport::TestCase
  test "basic associations" do
    one = attendances(:one)
    assert_kind_of Person, one.person
    assert_kind_of Event, one.event
    assert_kind_of Ticket, one.tickets.first
  end


end
