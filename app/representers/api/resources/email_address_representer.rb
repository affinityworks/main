class Api::Resources::EmailAddressRepresenter < Api::Resources::Representer
  property :address
  property :address_type
  property :primary
  property :status
end
