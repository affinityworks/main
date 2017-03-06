require 'roar/client'
require 'roar/json/hal'

class Api::AttendancesRepresenter < Roar::Decorator
  include Roar::Client
  include Roar::JSON::HAL

  collection :attendances, as: 'osdi:attendances', class: Attendance, extend: Api::AttendanceRepresenter, embedded: true
end
