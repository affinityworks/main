require 'roar/json/json_api'

class JsonApi::MemberRepresenter < Roar::Decorator
  include Roar::JSON::JSONAPI.resource :people

  attributes do
    property :id
    property :family_name
    property :given_name
    property :primary_email_address
    property :primary_phone_number
    property :attended_events_count
    property :custom_fields
    property :primary_personal_address, decorator: Api::Resources::AddressRepresenter, class: PersonalAddress
  end

  has_many :groups, extend: JsonApi::MembershipGroupRepresenter
end
