require 'roar/json/json_api'

class JsonApi::PersonRepresenter < Roar::Decorator
  include Roar::JSON::JSONAPI.resource :person

  attributes do
    property :name
    property :primary_email_address
  end
end
