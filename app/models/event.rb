class Event < ApplicationRecord
  has_many :ticket_levels

  belongs_to :location, class_name: 'Address', foreign_key: :address_id
  belongs_to :creator, class_name: 'Person'
  belongs_to :organizer, class_name: 'Person'
  belongs_to :modified_by, class_name: 'Person'
  has_many :attendances
  has_many :reminders

  # Import events from Action Network OSDI API.
  # Requires ACTION_NETWORK_API_TOKEN set in ENV.
  # There are no external endpoints for this method yet.
  def self.import!
    events = Api::Events.new
    client = Api::EventsRepresenter.new(events)
    client.get(uri: 'https://actionnetwork.org/api/v2/events', as: 'application/json') do |request|
      request['OSDI-API-TOKEN'] = Rails.application.secrets.action_network_api_token
    end
    events.events.each(&:save!)
  end
end
