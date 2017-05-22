module Api::ActionNetwork::Attendance
  extend Api::ActionNetwork::Export

  def self.export!(attendance, group)
    event_id = attendance.event.identifier_id('action_network')
    export_uri = "https://actionnetwork.org/api/v2/events/#{event_id}/attendances"
    export_single_resource(attendance, group, export_uri)
  end

  def self.representer_class
    Api::ActionNetwork::ExportAttendanceRepresenter
  end

  def self.resource
    'attendance'
  end
end
