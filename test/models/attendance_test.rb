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
    event_id = attendance.event.identifier_id('action_network')

    assert_not attendance.synced

    stub_request(:post, url(event_id)).to_return(status: 200)
    stub_request(:post, url(event_id)).to_return(status: 200)

    attendance.export(group)
    attendance.reload
    assert attendance.synced
  end

  test 'send_to_action_network_att_event' do
    attendance = attendances(:seven)
    att_event_id = attendance.event.attendance_event.identifier_id('action_network')
    event_id = attendance.event.identifier_id('action_network')

    stub_request(:post, url(event_id))
      .to_return(status: 200,
                 body: File.read(Rails.root.join('test', 'fixtures', 'files',
                                                 'attendances',
                                                 'original_attendance.json')))
    stub_request(:post, url(att_event_id))
      .to_return(status: 200,
                 body: File.read(Rails.root.join('test', 'fixtures', 'files',
                                                 'attendances',
                                                 'yes_attendance.json')))

    assert attendance.send_to_att_event_action_network, true

    attendance.update(attended: false)

    att_event_id = attendance.event.no_attendance_event.identifier_id('action_network')
    stub_request(:post, url(att_event_id))
      .to_return(status: 200,
                 body: File.read(Rails.root.join('test', 'fixtures', 'files',
                                                 'attendances',
                                                 'no_attendance.json')))

    assert attendance.send_to_att_event_action_network, true
  end

  def url(event_id)
    "https://actionnetwork.org/api/v2/events/#{event_id}/attendances"
  end
end
