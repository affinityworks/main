require 'roar/json/hal'

class Api::EventRepresenter < Roar::Decorator
  include Roar::JSON::HAL

  property :name
  property :title
end
