class Api::Collections::EventsRepresenter < Api::Collections::Representer
  collection :events, as: 'osdi:events', class: Event, extend: Api::Resources::EventRepresenter, embedded: true
end
