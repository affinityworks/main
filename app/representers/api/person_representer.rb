require 'roar/json/hal'

class Api::PersonRepresenter < Roar::Decorator
  include Roar::JSON::HAL

  property :created_at, as: :created_date
  property :ethnicities
  property :id
  property :given_name
  property :updated_at, as: :modified_date

  property :identifiers, exec_context: :decorator

  def identifiers
    ["osdi:#{ActiveModel::Naming.singular(represented)}-#{represented.id}"]
  end
end
