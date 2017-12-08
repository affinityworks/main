require 'roar/client'
require 'roar/json/hal'

class Api::ActionNetwork::Export::EventRepresenter < Roar::Decorator
  include Roar::Client
  include Roar::JSON::HAL

  property :identifiers
  property :title

  link 'osdi:organizer' do
    person_id = represented.creator&.identifier_id('action_network')
    "https://actionnetwork.org/api/v2/people/#{person_id}" if person_id
  end
end
