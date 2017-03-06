class Api::EmailAddressRepresenter < Api::Representer
  property :address
  property :primary?, as: :primary
end
