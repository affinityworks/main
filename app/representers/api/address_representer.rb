require 'roar/json/hal'

class Api::AddressRepresenter < Roar::Decorator
  include Roar::JSON::HAL

  property :address_type
  property :country
  property :language
  property :locality
  property :occupation
  property :postal_code
  property :primary?, as: :primary
  property :region
  property :status
  property :venue
  property :venue

  # json.location do
  #   address.latitude
  #   address.location_accuracy
  #   address.longitude
  # end
end
