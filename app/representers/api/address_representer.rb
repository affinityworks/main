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

  nested :location do
    property :latitude
    property :location_accuracy
    property :longitude
  end
end
