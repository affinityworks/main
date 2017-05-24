module Api::ActionNetwork::Events
  extend Api::ActionNetwork::Import

  def self.resource
    'event'
  end

  def self.import!(group)
    existing_count = 0
    new_count = 0
    updated_count = 0
    next_uri = first_uri(synced_at: group.synced_at)

    logger.info "Api::ActionNetwork::Events#import! from #{next_uri}"

    Event.transaction do
      while next_uri
        events, next_uri = request_resources_from_action_network(next_uri, group)

        existing_events, new_events = partition(events)

        new_count += new_events.size
        existing_count += existing_count.size
        updated_count = update_resources(existing_events)

        new_events = associate_with_group(new_events, group)

        create new_events
      end
      logger.debug "Api::ActionNetwork::Events#import! new: #{new_count} existing: #{existing_count} updated: #{updated_count}"
    end
  end

  def self.create_single_resource(event)
    assign_person_to_event(event, :organizer)
    assign_person_to_event(event, :creator)

    event.tap(&:save!)
  rescue StandardError => e
    logger.error resource
    raise e
  end

  def self.associate_with_group(new_events, group)
    new_events.each do |event|
      event.groups.push(group)
      event.organizer.groups.push(group)   if event.organizer
      event.creator.groups.push(group)      if event.creator
      event.modified_by.groups.push(group) if event.modified_by
    end
  end

  def self.assign_person_to_event(event, person_relation)
    address = event.send(person_relation)&.primary_email_address

    if address && email = EmailAddress.where(address: address).first
      event.send("#{person_relation}=",  email.person)
    end
  end
end
