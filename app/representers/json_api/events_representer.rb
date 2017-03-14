require 'roar/json/json_api'

class JsonApi::EventsRepresenter < Roar::Decorator
  include Roar::JSON::JSONAPI.resource :events

  attributes do
    property :name
    property :title
  end
end
