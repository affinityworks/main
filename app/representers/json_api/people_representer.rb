require 'roar/json/json_api'

class JsonApi::PeopleRepresenter < Roar::Decorator
  include Roar::JSON::JSONAPI.resource :people

  attributes do
    property :family_name
    property :given_name
    property :primary_email_address
    property :primary_phone_number
    property :attended_events_count
    property :primary_personal_address, decorator: Api::Resources::AddressRepresenter, class: PersonalAddress
  end
end
