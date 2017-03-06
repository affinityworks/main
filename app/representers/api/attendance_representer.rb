class Api::AttendanceRepresenter < Api::Representer
  include Api::IndependentResource
  property :status
end
