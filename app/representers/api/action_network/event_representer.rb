class Api::ActionNetwork::EventRepresenter < Api::Resources::EventRepresenter
  property :organizer, as: 'osdi:organizer', decorator: Api::Resources::PersonRepresenter, class: Person
  property :creator, as: 'osdi:creator', decorator: Api::Resources::PersonRepresenter, class: Person
end
