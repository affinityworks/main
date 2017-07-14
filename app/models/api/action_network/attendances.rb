module Api::ActionNetwork::Attendances
  extend Api::ActionNetwork::Import

  def self.resource
    'attendance'
  end

  def self.representer_class
    Api::ActionNetwork::AttendancesRepresenter
  end

  def self.import!(event, group)
    errors_count = 0
    existing_count = 0
    new_count = 0
    updated_count = 0
    action_network_event_id = event.identifier_id('action_network') || return

    next_uri = first_uri(action_network_event_id: action_network_event_id, synced_at: group.synced_at)

    logger.info "Api::ActionNetwork::Attendances#import! from #{next_uri}"

    #::Attendance.transaction do
      while next_uri
        attendances, next_uri = request_resources_from_action_network(next_uri, group)

        existing_attendances, new_attendances = partition(attendances)

        new_count += new_attendances.size
        existing_count += existing_count.size
        updated_count = update_resources(existing_attendances)

        new_attendances = associate_with_person(new_attendances, event.id, group)
        new_attendances = add_origin(new_attendances)

        new_attendances.each do |attendance|
          begin
            attendance.save!
          rescue ActiveRecord::RecordInvalid
            errors_count += 1
            logger.debug "FAILED TO IMPORT DUPLICATE ATTENDANCE - event_id: #{attendance.event_id} person_id: #{attendance.person_id} an_uuid: #{attendance.person_uuid}"
          end
        end
      end
      logger.debug "Api::ActionNetwork::Attendances#import! new: #{new_count} existing: #{existing_count} updated: #{updated_count}"
    #end

    {
      created: new_count,
      updated: updated_count,
      errors: errors_count
    }
  end

  def self.associate_with_person(new_attendances, event_id, group)
    new_attendances.map do |attendance|
      person = find_or_import_person(attendance.person_uuid, group)
      next unless person
      attendance.event_id = event_id
      attendance.person_id = person.id
      attendance
    end.compact
  end

  def self.add_origin(new_attendances)
    action_network = Origin.action_network

    new_attendances.each do |attendance|
      attendance.origins.push(action_network)
    end
  end

  def self.find_or_import_person(person_uuid, group)
    Person.any_identifier("action_network:#{person_uuid}").first ||
      Api::ActionNetwork::Person.import!(person_uuid, group)
  end

  def self.first_uri(params={})
    uri = "https://actionnetwork.org/api/v2/events/#{params[:action_network_event_id]}/attendances"
    add_uri_filter(uri, params[:synced_at])
  end
end
