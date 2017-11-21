require 'test_helper'

class NoAttendanceEventTest < ActiveSupport::TestCase

  test 'export_attendace' do
    attendance = attendances(:seven)
    no_attendance_event = attendance.event.no_attendance_event
    att_event_id = no_attendance_event.identifier_id('action_network')
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
                                                 'no_attendance.json')))
    attendance_identifier = '6216ce97-d826-46fc-a670-a3c3c0d5783f'
    no_att_identifier = 'f0266b45-1ff1-4680-8221-5f9e1f3046ec'

    no_attendance_event.export_attendace(attendance)

    assert attendance.identifier_id('action_network'), attendance_identifier
    assert attendance.identifier_id('no_att_identifier'), no_att_identifier
  end

  def url(event_id)
    "https://actionnetwork.org/api/v2/events/#{event_id}/attendances"
  end

end
