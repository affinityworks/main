class Api::Attendances
  attr_accessor :attendances

  # Import event attendances from Action Network OSDI API.
  # Requires ACTION_NETWORK_API_TOKEN set in ENV.
  # There are no external endpoints for this method yet.
  def self.import!(event)
    event_id = event.identifier_id('action_network')
    logger.info "Api::Attendances#import! from https://actionnetwork.org/api/v2/events/#{event_id}/attendances"

    attendances = request_attendances_from_action_network(event_id)

    Attendance.transaction do
      existing_attendances, new_attendances = partition_attendances(attendances)
      updated_count = update_attendances(existing_attendances)
      logger.debug "Api::Attendances#import! new: #{new_attendances.size} existing: #{existing_attendances.size} updated: #{updated_count}"
      new_attendances.each(&:save!)
    end
  end

  def self.request_attendances_from_action_network(event_id)
    attendances = Api::Attendances.new
    client = Api::AttendancesRepresenter.new(attendances)
    client.get(uri: "https://actionnetwork.org/api/v2/events/#{event_id}/attendances", as: 'application/json') do |request|
      request['OSDI-API-TOKEN'] = Rails.application.secrets.action_network_api_token
    end

    logger.debug "Api::Attendances#import! attendances: #{attendances.attendances.size}"
    attendances.attendances
  end

  def self.partition_attendances(attendances)
    attendances.partition do |attendance|
      # TODO: Make this Model.identifier and rename identifier scope
      action_network_identifier = attendance.identifier('action_network')
      # TODO: make this a single method on model
      Attendance.any_identifier(action_network_identifier).exists?
    end
  end

  # Update all attributes for attendances that already exist and have not been modified after import
  # We may want to do something different
  def self.update_attendances(existing_attendances)
    updated_count = 0
    existing_attendances.each do |attendance|
      action_network_identifier = attendance.identifier('action_network')
      # TODO: make this a single scope?
      old_attendance = Attendance
                       .any_identifier(action_network_identifier)
                       .where('updated_at < ?', attendance.updated_at)
                       .first

      if old_attendance
        updated_count += 1
        attributes = attendance.attributes
        attributes.delete_if { |k, v| v.nil? }
        old_attendance.update_attributes! attributes
      end
    end

    updated_count
  end

  def self.logger
    Attendance.logger
  end
end
