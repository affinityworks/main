require 'test_helper'

class AttendanceEventTest < ActiveSupport::TestCase

  test 'export_attendace' do
    attendance = attendances(:seven)
    attendance_event = attendance.event.attendance_event
    att_event_id = attendance_event.identifier_id('action_network')
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
    attendance_identifier = '6216ce97-d826-46fc-a670-a3c3c0d5783f'
    att_event_identifier = '759e3729-c780-4e68-8d5f-12ff739c719e'

    attendance_event.export_attendace(attendance)

    assert attendance.identifier_id('action_network'), attendance_identifier
    assert attendance.identifier_id('att_identifier'), att_event_identifier
  end

  def url(event_id)
    "https://actionnetwork.org/api/v2/events/#{event_id}/attendances"
  end

end
