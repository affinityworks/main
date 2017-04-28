require 'roar/json/hal'

class Api::Resources::Representer < Roar::Decorator
  include Roar::JSON::HAL
end
