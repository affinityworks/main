class AttendanceEvent < RemoteEvent
  include HasAttendanceEvent

  def self.att_event_name(event_title)
    "#{event_title}_ATT"
  end

  # may be applied to event title, name, or identifier strings
  def self.replicate_attr(attribute)
    "#{attribute}_ATT"
  end
end
