require 'roar/json/hal'

class Api::AttendanceRepresenter < Roar::Decorator
  include Roar::JSON::HAL

  property :created_at, as: :created_date
  property :identifiers
  property :updated_at, as: :modified_date

  property :status

  link :self do
    "/api/v1/attendances/#{represented.id}"
  end
end
