class AttendanceEvent < RemoteEvent
  include HasAttendanceEvent

  def self.att_event_name(event_title)
    "#{event_title}_ATT"
  end

end

