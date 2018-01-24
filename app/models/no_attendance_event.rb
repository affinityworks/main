class NoAttendanceEvent < RemoteEvent
  include HasAttendanceEvent

  def self.att_event_name(event_title)
      "#{event_title}_NO_ATT"
  end

  # may be used on either event title, name, or identifier strings
  def self.replicate_attr(attribute)
    "#{attribute}_NO_ATT"
  end
end
