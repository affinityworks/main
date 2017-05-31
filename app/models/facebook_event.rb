class FacebookEvent < RemoteEvent
  def self.initialize_for_event(event_id, remote_event)
    FacebookEvent.new(
      event_id: event_id,
      uid: remote_event['id'],
      name: remote_event['name'],
      description: remote_event['description'],
      start_date: remote_event['start_time'],
      end_date: remote_event['start_time']
    )
  end

  def attendances(identity)
    Facebook::EventAttendance.new(identity, uid).attendances
  end
end
