class Api::Resources::AttendanceRepresenter < Api::Resources::Representer
  include Api::Resources::Identified
  property :status
  property :attended
end
