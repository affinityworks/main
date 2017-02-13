require 'roar/json/hal'

class Api::PersonRepresenter < Roar::Decorator
  include Roar::JSON::HAL

  property :created_at, as: :created_date
  property :updated_at, as: :modified_date

  property :identifiers, exec_context: :decorator

  property :additional_name
  property :birthdate, decorator: Api::BirthdateRepresenter
  property :custom_fields
  property :employer
  property :ethnicities
  property :family_name
  property :gender
  property :gender_identity
  property :given_name
  property :honorific_prefix
  property :honorific_suffix
  property :languages_spoken
  property :party_identification
  property :source

  collection :email_addresses, decorator: Api::EmailAddressRepresenter
  property :employer_address, decorator: Api::AddressRepresenter
  collection :personal_addresses, as: :postal_addresses, decorator: Api::AddressRepresenter

  collection :phone_numbers, decorator: Api::PhoneNumberRepresenter
  collection :profiles, decorator: Api::ProfileRepresenter

  def identifiers
    ["advocacycommons:#{represented.id}"]
  end
end
