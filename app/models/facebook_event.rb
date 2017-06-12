class FacebookEvent < RemoteEvent
  def self.find_or_initialize_for_event(event_id, remote_event)
    FacebookEvent.find_or_initialize_by(event_id: event_id).tap do |fb_event|
      fb_event.event_id = event_id
      fb_event.uid = remote_event['id']
      fb_event.name = remote_event['name']
      fb_event.description = remote_event['description']
      fb_event.start_date = remote_event['start_time']
      fb_event.end_date = remote_event['start_time']

      puts fb_event.event_id
    end
  end

  def attendances(identity)
    Facebook::EventAttendance.new(identity, uid).attendances
  end
end
