require 'roar/json/hal'

class Api::BirthdateRepresenter < Roar::Decorator
  include Roar::JSON::HAL

  property :day
  property :month
  property :year
end
