require 'roar/json/json_api'

class JsonApi::EventsRepresenter < Roar::Decorator
  include Roar::JSON::JSONAPI.resource :events

  attributes do
    property :invited_count
    property :organizer, decorator: JsonApi::PersonRepresenter
    property :name
    property :start_date
    property :status
    property :title
    property :rsvp_count
    property :attended_count
    property :invited_count    
  end
end
