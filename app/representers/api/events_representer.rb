require 'roar/client'
require 'roar/json/hal'

class Api::EventsRepresenter < Roar::Decorator
  include Roar::Client
  include Roar::JSON::HAL

  collection :events, as: 'osdi:events', class: Event, extend: Api::EventRepresenter, embedded: true
end
