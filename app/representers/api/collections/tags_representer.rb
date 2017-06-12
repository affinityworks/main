class Api::Collections::TagsRepresenter < Api::Collections::Representer
  collection :tags, as: 'osdi:tags', class: Tag, extend: Api::Resources::TagRepresenter, embedded: true

  link :next
end
