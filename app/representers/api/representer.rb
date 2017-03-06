require 'roar/json/hal'

class Api::Representer < Roar::Decorator
  include Roar::JSON::HAL
end
