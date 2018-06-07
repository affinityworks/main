require 'roar/json/json_api'

class JsonApi::GroupRepresenter < Roar::Decorator
  include Roar::JSON::JSONAPI.resource :group

  attributes do
    property :name
    property :description
    property :summary
    property :origin_system
    property :browser_url
    property :featured_image_url
    property :signup_url
    property :join_url
    property :new_subgroup_url
    property :google_group_url
    property :google_group_email
    property :whiteboard
    property :feature_toggles, default: {}

    property :creator, extend: JsonApi::PeopleRepresenter, class: Person
  end

  has_many :upcoming_events, extend: JsonApi::EventsRepresenter
end
