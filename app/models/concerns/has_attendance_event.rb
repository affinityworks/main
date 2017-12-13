module HasAttendanceEvent
  extend ActiveSupport::Concern
  include Api::Identifiers

  included do
    belongs_to :event

    def self.create_and_sync(event)
      event_dup = event.dup
      event_dup.origin_system = 'Affinity'
      event_dup.title = att_event_name(event.title)
      event_dup.name = att_event_name(event.title)
      event_dup.identifiers = []
      event_dup = Api::ActionNetwork::Event.export!(event_dup, event.group, false)
      create_att_event(event_dup, event) if event_dup
    end

    def self.create_att_event(event_dup, event)
      create(name: event_dup.title,
             uid: event_dup.identifier('action_network'),
             identifiers: event_dup.identifiers, event_id: event.id)
    end
  end


  def export_attendace(attendance)
    group = attendance.event.group
    attendance_dup = attendance.dup
    event_identifier = identifier_id('action_network')

    att_event_identifier = remote_att_event_identifier(attendance)
    remote_identifier = rename_remote_identifier(att_event_identifier)

    attendance_dup.identifiers = []
    attendance_dup.identifiers << remote_identifier if remote_identifier

    attendance_dup = Api::ActionNetwork::RemoteAttendance.export!(attendance_dup,
                                                                  group, event_identifier)

    attendance = save_remote_att_event_identifier(attendance, attendance_dup)

    attendance
  end

  private

  def rename_remote_identifier(att_event_identifier)
    att_event_identifier&.gsub(attendance_identifier_prefix, 'action_network')
  end

  def remote_att_event_identifier(attendance)
    attendance.identifier(attendance_identifier_prefix)
  end

  def attendance_identifier_prefix
    is_a?(AttendanceEvent) ? 'att_identifier' : 'no_att_identifier'
  end

  def save_remote_att_event_identifier(attendance, attendance_dup)
    identifier_name = attendance_identifier_prefix
    identifier_name_value = attendance_dup.identifier_id('action_network')
    remote_identifier = "#{identifier_name}:#{identifier_name_value}"
    return attendance if attendance.identifier?(remote_identifier)
    attendance.add_identifier(identifier_name, identifier_name_value)
    attendance
  end
end
