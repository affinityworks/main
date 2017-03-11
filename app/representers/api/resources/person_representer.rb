class Api::Resources::PersonRepresenter < Api::Resources::Representer
  include Api::Resources::Identified

  property :additional_name
  property :birthdate, decorator: Api::Resources::BirthdateRepresenter
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

  collection :email_addresses, decorator: Api::Resources::EmailAddressRepresenter, class: EmailAddress
  property :employer_address, decorator: Api::Resources::AddressRepresenter, class: EmployerAddress
  collection :personal_addresses, as: :postal_addresses, decorator: Api::Resources::AddressRepresenter, class: PersonalAddress

  collection :phone_numbers, decorator: Api::Resources::PhoneNumberRepresenter, class: PhoneNumber
  collection :profiles, decorator: Api::Resources::ProfileRepresenter, class: Profile
end
