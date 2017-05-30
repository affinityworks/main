require 'roar/json/json_api'

class JsonApi::PersonRepresenter < Roar::Decorator
  include Roar::JSON::JSONAPI.resource :person

  attributes do
    property :id
    property :name
    property :primary_email_address
    property :identifiers
  end
end
