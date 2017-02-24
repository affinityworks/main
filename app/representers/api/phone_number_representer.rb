require 'roar/json/hal'

class Api::PhoneNumberRepresenter < Roar::Decorator
  include Roar::JSON::HAL

  property :country
  property :description
  property :do_not_call, as: :do_not_call?
  property :extension
  property :number
  property :number_type
  property :operator
  property :primary?, as: :primary
  property :sms_capable
end
