require 'roar/client'
require 'roar/json/hal'

class Api::ActionNetwork::Export::AttendanceRepresenter < Roar::Decorator
  include Roar::Client
  include Roar::JSON::HAL

  property :identifiers
  property :status

  link 'osdi:person' do
    person_id = represented.person.identifier_id('action_network')
    "https://actionnetwork.org/api/v2/people/#{person_id}"
  end

end
