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
    address = event.organizer&.primary_email_address

    if address && email = EmailAddress.where(address: address).first
      #NOTE: Roar was creating duplicated people as organizer in some cases.
      event.organizer = email.person
    end

    event.tap(&:save!)
  rescue StandardError => e
    logger.error resource
    raise e
  end

  def self.associate_with_group(new_events, group)
    new_events.each do |event|
      event.groups.push(group)
      if event.organizer
        event.organizer.groups.push(group)
      end
    end
  end
end
