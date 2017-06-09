require 'roar/json/json_api'

class JsonApi::MembershipRepresenter < Roar::Decorator
  include Roar::JSON::JSONAPI.resource :membership

  attributes do
    property :role

    property :person, extend: JsonApi::MemberRepresenter, class: Person
    property :group, extend: JsonApi::GroupsRepresenter, class: Group
    collection :tags, extend: JsonApi::TagsRepresenter
  end
end
