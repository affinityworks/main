module Api::ActionNetwork::RemoteAttendance
  extend Api::ActionNetwork::Export

  class << self
    def export!(attendance, group, event_identifier)
      export_uri = "https://actionnetwork.org/api/v2/events/#{event_identifier}/attendances"
      export_single_resource(attendance, group, export_uri, false)
    end

    def representer_class
      Api::ActionNetwork::Export::AttendanceRepresenter
    end

    def resource
      'attendance'
    end
  end
end
