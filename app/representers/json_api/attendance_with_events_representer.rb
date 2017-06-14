class JsonApi::AttendanceWithEventsRepresenter < JsonApi::AttendancesRepresenter
  attributes do
    property :event, extend: JsonApi::EventsRepresenter, class: Event
  end
end
