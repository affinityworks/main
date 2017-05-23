require 'roar/client'
require 'roar/json/hal'

class Api::ActionNetwork::ExportAttendanceRepresenter < Roar::Decorator
  include Roar::Client
  include Roar::JSON::HAL

  link 'osdi:person' do
    person_id = represented.person.identifier_id('action_network')
    "https://actionnetwork.org/api/v2/people/#{person_id}"
  end

  link 'osdi:event' do
    event_id = represented.event.identifier_id('action_network')
    "https://actionnetwork.org/api/v2/events/#{event_id}"
  end
end
