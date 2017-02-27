require 'test_helper'

class EventTest < ActiveSupport::TestCase
  test 'basic associations' do
    one = events(:one)
    assert_kind_of TicketLevel, one.ticket_levels.first
    assert_kind_of Address, one.location
    assert_kind_of Person, one.creator
    assert_kind_of Person, one.organizer
    assert_kind_of Person, one.modified_by
    assert_kind_of Attendance, one.attendances.first
    assert_kind_of Reminder, one.reminders.first
  end
end
