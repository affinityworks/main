class Api::Collections::TaggingsRepresenter < Api::Collections::Representer
  collection :taggings, as: 'osdi:taggings', class: OpenStruct, extend: Api::Resources::TaggingRepresenter, embedded: true

  link :next
end
