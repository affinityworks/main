class Api::Resources::EmailAddressRepresenter < Api::Resources::Representer
  property :address
  property :primary?, as: :primary
end
