class Api::ActionNetwork::Events
  include Api::ActionNetwork::Collections

  attr_accessor :events

  # Import events from Action Network OSDI API.
  # Requires ACTION_NETWORK_API_TOKEN set in ENV.
  # There are no external endpoints for this method yet.
  def self.import!
    logger.info 'Api::ActionNetwork::Events#import! from https://actionnetwork.org/api/v2/events'

    events = request_events_from_action_network

    Event.transaction do
      existing_events, new_events = partition_events(events)
      updated_count = update_events(existing_events)
      logger.debug "Api::ActionNetwork::Events#import! new: #{new_events.size} existing: #{existing_events.size} updated: #{updated_count}"
      new_events.each(&:save!)
    end
  end

  def self.request_events_from_action_network
    action_network = Api::ActionNetwork::Events.new
    client = Api::Collections::EventsRepresenter.new(action_network)
    client.get(uri: 'https://actionnetwork.org/api/v2/events', as: 'application/json') do |request|
      request['OSDI-API-TOKEN'] = Rails.application.secrets.action_network_api_token
    end

    logger.debug "Api::ActionNetwork::Events#import! events: #{action_network.events.size}"
    action_network.events
  end

  def self.partition_events(events)
    events.partition do |event|
      action_network_identifier = event.identifiers.detect { |identifier| identifier['action_network:'] }
      Event.any_identifier(action_network_identifier).exists?
    end
  end

  # Update all attributes for events that already exist and have not been modified after import
  # We may want to do something different
  def self.update_events(existing_events)
    updated_count = 0
    existing_events.each do |event|
      old_event = Event.outdated_existing(event, 'action_network').first

      if old_event
        updated_count += 1
        attributes = event.attributes
        attributes.delete_if { |k, v| v.nil? }
        old_event.update_attributes! attributes
      end
    end

    updated_count
  end

  def self.logger
    Event.logger
  end
end
