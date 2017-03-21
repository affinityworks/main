module Api::ActionNetwork::Attendances
  extend Api::ActionNetwork::Import

  def self.resource
    'attendance'
  end

  def self.representer_class
    Api::ActionNetwork::AttendancesRepresenter
  end

  def self.import!(event)
    existing_count = 0
    new_count = 0
    updated_count = 0
    action_network_event_id = event.identifier_id('action_network')
    next_uri = "https://actionnetwork.org/api/v2/events/#{action_network_event_id}/attendances"

    logger.info "Api::ActionNetwork::Attendances#import! from #{next_uri}"

    Attendance.transaction do
      while next_uri
        attendances, next_uri = request_resources_from_action_network(next_uri)

        existing_attendances, new_attendances = partition(attendances)

        new_count += new_attendances.size
        existing_count += existing_count.size
        updated_count = update_resources(existing_attendances)

        new_attendances = associate_with_person(new_attendances, event.id)
        new_attendances.each(&:save!)
      end
      logger.debug "Api::ActionNetwork::Attendances#import! new: #{new_count} existing: #{existing_count} updated: #{updated_count}"
    end
  end

  def self.associate_with_person(new_attendances, event_id)
    new_attendances.each do |attendance|
      attendance.event_id = event_id
      person = Person.any_identifier("action_network:#{attendance.person_uuid}").first!
      attendance.person_id = person.id
    end
  end
end
