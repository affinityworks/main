class Api::Resources::AddressRepresenter < Api::Resources::Representer
  property :address_type
  property :country
  property :language
  property :locality
  property :occupation
  property :postal_code
  property :primary
  property :region
  property :status
  property :venue
  property :address_lines

  nested :location do
    property :latitude
    property :location_accuracy
    property :longitude
  end
end
