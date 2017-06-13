require 'roar/json/json_api'

class JsonApi::NotesRepresenter < Roar::Decorator
  include Roar::JSON

  property :text
  property :id
  property :author do
    property :name
  end
end
