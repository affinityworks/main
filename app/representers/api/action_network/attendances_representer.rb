class Api::ActionNetwork::AttendancesRepresenter < Api::AttendancesRepresenter
  collection :attendances, as: 'osdi:attendances', class: Attendance, extend: Api::ActionNetwork::AttendanceRepresenter, embedded: true
end
