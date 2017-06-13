require 'roar/client'
require 'roar/json/hal'

class Api::ActionNetwork::Export::TaggingRepresenter < Roar::Decorator
  include Roar::Client
  include Roar::JSON::HAL

  link 'osdi:person' do
    person_id = represented.taggable.identifier_id('action_network')
    "https://actionnetwork.org/api/v2/people/#{person_id}"
  end
end
