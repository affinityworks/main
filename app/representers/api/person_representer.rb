class Api::PersonRepresenter < Api::Representer
  include Api::IndependentResource

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
end
