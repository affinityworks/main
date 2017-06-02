class Api::Collections::AttendancesRepresenter < Api::Collections::Representer
  collection :attendances, as: 'osdi:attendances', class: Attendance, extend: Api::Resources::AttendanceRepresenter, embedded: true

  link :next
end
