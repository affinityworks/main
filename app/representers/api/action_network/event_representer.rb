class Api::ActionNetwork::EventRepresenter < Api::Resources::EventRepresenter
  property :organizer, as: 'osdi:organizer', decorator: Api::Resources::PersonRepresenter, class: Person
end
