require 'test_helper'

class AttendanceTest < ActiveSupport::TestCase
  test "basic associations" do
    one = attendances(:one)
    assert_kind_of Person, one.person
    assert_kind_of Event, one.event
    assert_kind_of Ticket, one.tickets.first
  end

  test 'export' do
    attendance = attendances(:two)
    group = attendance.person.groups.first
    attendance.update_attribute(:synced, false)
    event_id = attendance.event.identifier_id('action_network')

    stub_request(
      :post, "https://actionnetwork.org/api/v2/events/#{event_id}/attendances"
    ).to_return(status: 200)

    assert_not attendance.synced
    attendance.export(group)
    attendance.reload
    assert attendance.synced
  end
end
