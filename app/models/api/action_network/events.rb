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

    #Event.transaction do
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
    #end

    {
      created: new_count,
      updated: updated_count,
      errors: errors_count
    }
  end

  def self.create_single_resource(event)
    assign_person_to_event(event, :organizer)
    assign_person_to_event(event, :creator)

    event.tap(&:save!)
  rescue StandardError => e
    logger.error resource
    self.errors_count = self.errors_count + 1
  end

  def self.associate_with_group(new_events, group)
    new_events.each do |event|
      event.groups.push(group)
      event.organizer.groups.push(group)   if event.organizer
      event.creator.groups.push(group)     if event.creator
      event.modified_by.groups.push(group) if event.modified_by
    end
  end

  def self.assign_person_to_event(event, person_relation)
    address = event.send(person_relation)&.primary_email_address

    if address && email = EmailAddress.where(address: address).first
      event.send("#{person_relation}=",  email.person)
    end
  end

  def self.merge_resources(old_resource, resource)
    attributes = resource.attributes
    location_attributes = resource.location.attributes

    attributes.delete_if { |_, v| v.nil? }
    location_attributes.delete_if { |_, v| v.nil? }

    if old_resource.location
      old_resource.location.update_attributes! location_attributes
    else
      old_resource.location = Address.new location_attributes
    end

    old_resource.update_attributes! attributes

    old_resource
  end

  def self.errors_count
    @errors_count ||= 0
  end

  def self.errors_count=(errors)
    @errors_count = errors
  end
end
