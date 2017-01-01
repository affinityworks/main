require 'test_helper'

class ReminderTest < ActiveSupport::TestCase
  test "basic associations" do
    one = reminders(:one)
    assert_kind_of Person, one.person
    assert_kind_of Event, one.event
  end
end
