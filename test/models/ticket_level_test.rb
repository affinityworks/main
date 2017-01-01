require 'test_helper'

class TicketLevelTest < ActiveSupport::TestCase
  test "basic associations" do
    one = ticket_levels(:one)
    assert_kind_of Event, one.event
  end
end
