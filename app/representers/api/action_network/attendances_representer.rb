class Api::ActionNetwork::AttendancesRepresenter < Api::Collections::AttendancesRepresenter
  collection :attendances, as: 'osdi:attendances', class: Attendance, extend: Api::ActionNetwork::AttendanceRepresenter, embedded: true
end
