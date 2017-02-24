require 'roar/json/hal'

class Api::EmailAddressRepresenter < Roar::Decorator
  include Roar::JSON::HAL

  property :address
  property :primary?, as: :primary
end
