module Api::ActionNetwork::Events
  extend Api::ActionNetwork::Import

  def self.resource
    'event'
  end

  def self.import!
    existing_count = 0
    new_count = 0
    updated_count = 0
    next_uri = first_uri

    logger.info "Api::ActionNetwork::Events#import! from #{next_uri}"

    Event.transaction do
      while next_uri
        events, next_uri = request_resources_from_action_network(next_uri)

        existing_events, new_events = partition(events)

        new_count += new_events.size
        existing_count += existing_count.size
        updated_count = update_resources(existing_events)

        create new_events
      end
      logger.debug "Api::ActionNetwork::Events#import! new: #{new_count} existing: #{existing_count} updated: #{updated_count}"
    end
  end
end
