module HasAttendanceEvent
  extend ActiveSupport::Concern
  include Api::Identifiers

  included do
    belongs_to :event, optional: true

    def self.replicate_and_export(event)
      return unless should_replicate? event
      if replica = Api::ActionNetwork::Event.
                     export!(parse_replica(event), event.group, false)
        create(name:        replica.title,
               uid:         replica.identifier('action_network'),
               identifiers: replica.identifiers,
               event_id:    event.id)
      end
    end

    private

    def self.should_replicate?(event)
      event.origin_system_is_action_network? && event.identifier('action_network')
    end

    def self.parse_replica(event)
      replica = event.dup
      replica.assign_attributes(
        origin_system: 'Affinity',
        title:         replicate_attr(event.title),
        name:          replicate_attr(event.title), # not sure why we copy title
        identifiers:   replicate_identifiers(event))
      replica
    end

    def self.replicate_identifiers(event)
      id = event.identifier_id("action_network")
      ["advocacycommons:#{replicate_attr(id)}"]
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
