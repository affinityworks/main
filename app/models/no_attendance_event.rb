class NoAttendanceEvent < RemoteEvent
  include HasAttendanceEvent

  def self.att_event_name(event_title)
    "#{event_title}_NO_ATT"
  end
end

