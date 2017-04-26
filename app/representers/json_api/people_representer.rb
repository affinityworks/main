require 'roar/json/json_api'

class JsonApi::PeopleRepresenter < Roar::Decorator
  include Roar::JSON::JSONAPI.resource :people

  attributes do
    property :family_name
    property :given_name
    property :primary_email_address
    property :primary_phone_number
  end
end
