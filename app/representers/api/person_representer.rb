require 'roar/json/hal'

class Api::PersonRepresenter < Roar::Decorator
  include Roar::JSON::HAL

  link :self do
    '/api/v1/people'
  end
end
