require 'roar/json/hal'
require 'roar/client'

class Api::ActionNetwork::PersonRepresenter < Api::Resources::PersonRepresenter
  include Roar::Client
  include Roar::JSON::HAL
end
