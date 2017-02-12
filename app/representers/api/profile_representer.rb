require 'roar/json/hal'

class Api::ProfileRepresenter < Roar::Decorator
  include Roar::JSON::HAL

  property :handle
  property :id
  property :provider
  property :url
end
