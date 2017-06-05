require 'roar/json/json_api'

class JsonApi::TagsRepresenter < Roar::Decorator
  include Roar::JSON

  property :name
  property :id
end
