class Event < ApplicationRecord
  has_many :ticket_levels

  belongs_to :location, class_name: 'Address', foreign_key: :address_id
  belongs_to :creator, class_name: 'Person'
  belongs_to :organizer, class_name: 'Person'
  belongs_to :modified_by, class_name: 'Person'
  has_many :attendances
  has_many :reminders

  after_save :add_identifier

  scope :identifier, ->(identifier) { where('? = any (identifiers)', identifier) }

  # Import events from Action Network OSDI API.
  # Requires ACTION_NETWORK_API_TOKEN set in ENV.
  # There are no external endpoints for this method yet.
  def self.import!
    logger.info 'Event#import! from https://actionnetwork.org/api/v2/events'

    events = Api::Events.new
    client = Api::EventsRepresenter.new(events)
    client.get(uri: 'https://actionnetwork.org/api/v2/events', as: 'application/json') do |request|
      request['OSDI-API-TOKEN'] = Rails.application.secrets.action_network_api_token
    end

    logger.debug "Event#import! events: #{events.events.size}"

    transaction do
      existing_events, new_events = events.events.partition do |event|
        action_network_identifier = event.identifiers.detect { |identifier| identifier['action_network:'] }
        Event.identifier(action_network_identifier).exists?
      end

      updated_count = 0
      existing_events.each do |event|
        action_network_identifier = event.identifiers.detect { |identifier| identifier['action_network:'] }
        old_event = Event
                    .identifier(action_network_identifier)
                    .where('updated_at < ?', event.updated_at)
                    .first

        if old_event
          updated_count += 1
          attributes = event.attributes
          attributes.delete_if { |k, v| v.nil? }
          old_event.update_attributes! attributes
        end
      end
      logger.debug "Event#import! new: #{new_events.size} existing: #{existing_events.size} updated: #{updated_count}"

      new_events.each(&:save!)
    end
  end

  def add_identifier
    identifier = "advocacycommons:#{id}"

    if identifiers.nil?
      self.identifiers = [identifier]
      save
    elsif identifiers.include?(identifier)
      true
    else
      identifiers << identifier
      save
    end
  end
end
