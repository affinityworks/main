class FacebookEvent < RemoteEvent
  def self.find_or_initialize_for_event(event_id, remote_event)
    if facebook_event = FacebookEvent.find_by_uid(remote_event['uid']) then
      facebook_event.event_id = event_id
      return facebook_event
    else 
      return FacebookEvent.new(
        event_id: event_id,
        uid: remote_event['id'],
        name: remote_event['name'],
        description: remote_event['description'],
        start_date: remote_event['start_time'],
        end_date: remote_event['start_time']
      )
    end
  end

  def attendances(identity)
    Facebook::EventAttendance.new(identity, uid).attendances
  end
end
