class Api::Resources::TaggingRepresenter < Api::Resources::Representer

  property :identifiers
  property '_links' #NOTE Hack, link :self or link 'osdi:person' does not work
end
