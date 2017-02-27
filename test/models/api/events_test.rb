require 'test_helper'

class Api::EventTest < ActiveSupport::TestCase
  test "basic associations" do
    one = events(:one)
    assert_kind_of TicketLevel, one.ticket_levels.first
    assert_kind_of Address, one.location
    assert_kind_of Person, one.creator
    assert_kind_of Person, one.organizer
    assert_kind_of Person, one.modified_by
    assert_kind_of Attendance, one.attendances.first
    assert_kind_of Reminder, one.reminders.first
  end

  test '.import!' do
    stub_request(:get, 'https://actionnetwork.org/api/v2/events')
      .with(headers: { 'OSDI-API-TOKEN' => 'test-token' })
      .to_return(body: File.read("#{Rails.root}/test/fixtures/files/events.json"))

    assert_difference 'Event.count', 2 do
      Event.import!
    end

    assert Event.where(name: 'March 14th Rally').exists
    assert Event.where(title: 'House Party for Progress').exists
  end
end
