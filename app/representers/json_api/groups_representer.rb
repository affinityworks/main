require 'roar/json/json_api'

class JsonApi::GroupsRepresenter < Roar::Decorator
  include Roar::JSON::JSONAPI.resource :group

  attributes do
    property :name

    property :creator, extend: JsonApi::PersonRepresenter, class: Person

    property :location, decorator: Api::Resources::AddressRepresenter, class: GroupAddress
    collection :tags, extend: JsonApi::TagsRepresenter
  end
end
