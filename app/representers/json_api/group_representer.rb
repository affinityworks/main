require 'roar/json/json_api'

class JsonApi::GroupRepresenter < Roar::Decorator
  include Roar::JSON::JSONAPI.resource :group

  attributes do
    property :name
    property :description
    property :summary
    property :origin_system
    property :browser_url
    property :featured_image_url

    property :creator, extend: JsonApi::PeopleRepresenter, class: Person
  end

  has_many :upcoming_events, extend: JsonApi::EventsRepresenter
end
