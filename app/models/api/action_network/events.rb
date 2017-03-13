module Api::ActionNetwork::Events
  extend Api::ActionNetwork::Import

  def self.resource_class
    Event
  end

  def self.import!
    logger.info 'Api::ActionNetwork::Events#import! from https://actionnetwork.org/api/v2/events'

    events = request_events_from_action_network

    Event.transaction do
      existing_events, new_events = partition(events)
      updated_count = update_events(existing_events)
      logger.debug "Api::ActionNetwork::Events#import! new: #{new_events.size} existing: #{existing_events.size} updated: #{updated_count}"
      new_events.each(&:save!)
    end
  end

  def self.request_events_from_action_network
    collection = Api::Collections::Events.new
    client = Api::Collections::EventsRepresenter.new(collection)
    client.get(uri: 'https://actionnetwork.org/api/v2/events', as: 'application/json') do |request|
      request['OSDI-API-TOKEN'] = Rails.application.secrets.action_network_api_token
    end

    logger.debug "Api::ActionNetwork::Events#import! events: #{collection.events.size}"
    collection.events
  end

  # Update all attributes for events that already exist and have not been modified after import
  # We may want to do something different
  def self.update_events(existing_events)
    updated_count = 0
    existing_events.each do |event|
      old_event = Event.outdated_existing(event, 'action_network').first

      next unless old_event

      updated_count += 1
      attributes = event.attributes
      attributes.delete_if { |_, v| v.nil? }
      old_event.update_attributes! attributes
    end

    updated_count
  end
end
