module HasAttendanceEvent
  extend ActiveSupport::Concern
  include Api::Identifiers

  included do
    belongs_to :event
  end

  def export_attendace(attendance)
    group = attendance.event.group
    attendance_dup = attendance.dup
    event_identifier = identifier_id('action_network')

    att_event_identifier = remote_att_event_identifier(attendance)
    remote_identifier = rename_remote_identifier(att_event_identifier)

    attendance_dup.identifiers = []
    attendance_dup.identifiers << remote_identifier if remote_identifier

    attendance_dup = Api::ActionNetwork::RemoteAttendance.export!(attendance_dup, group, event_identifier)

    attendance = save_remote_att_event_identifier(attendance, attendance_dup)

    attendance
  end

  private

  def rename_remote_identifier(att_event_identifier)
    if is_a?(AttendanceEvent)
      att_event_identifier&.gsub('action_network_att_event', 'action_network')
    else
      att_event_identifier&.gsub('action_network_no_att_event', 'action_network')
    end
  end

  def remote_att_event_identifier(attendance)
    if is_a?(AttendanceEvent)
      return attendance.identifier('action_network_att_event')
    else
      return attendance.identifier('action_network_no_att_event')
    end
  end

  def save_remote_att_event_identifier(attendance, attendance_dup)
    identifier_name = is_a?(AttendanceEvent) ? 'action_network_att_event' : 'action_network_no_att_event'
    remote_identifier = "#{identifier_name}:#{attendance_dup.identifier_id('action_network')}"
    attendance.identifiers << remote_identifier unless attendance.identifier?(remote_identifier)
    attendance.save
    attendance
  end
end
