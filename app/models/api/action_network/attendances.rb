module Api::ActionNetwork::Attendances
  extend Api::ActionNetwork::Import

  def self.resource
    'attendance'
  end

  def self.representer_class
    Api::ActionNetwork::AttendancesRepresenter
  end

  def self.import!(event, group)
    existing_count = 0
    new_count = 0
    updated_count = 0
    action_network_event_id = event.identifier_id('action_network') || return

    next_uri = first_uri(action_network_event_id: action_network_event_id)

    logger.info "Api::ActionNetwork::Attendances#import! from #{next_uri}"

    Attendance.transaction do
      while next_uri
        attendances, next_uri = request_resources_from_action_network(next_uri, group)

        existing_attendances, new_attendances = partition(attendances)

        new_count += new_attendances.size
        existing_count += existing_count.size
        updated_count = update_resources(existing_attendances)

        new_attendances = associate_with_person(new_attendances, event.id, group)
        new_attendances.each(&:save!)
      end
      logger.debug "Api::ActionNetwork::Attendances#import! new: #{new_count} existing: #{existing_count} updated: #{updated_count}"
    end
  end

  def self.associate_with_person(new_attendances, event_id, group)
    new_attendances.each do |attendance|
      attendance.event_id = event_id
      person = find_or_import_person(attendance.person_uuid, group)
      attendance.person_id = person.id
    end
  end

  def self.find_or_import_person(person_uuid, group)
    Person.any_identifier("action_network:#{person_uuid}").first ||
      Api::ActionNetwork::Person.import!(person_uuid, group)
  end

  def self.first_uri(params={})
    "https://actionnetwork.org/api/v2/events/#{params[:action_network_event_id]}/attendances"
  end
end
