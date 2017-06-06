require 'roar/json/json_api'

class JsonApi::MembershipGroupRepresenter < Roar::Decorator
  include Roar::JSON

  property :name
  property :id
end
