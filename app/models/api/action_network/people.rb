module Api::ActionNetwork::People
  extend Api::ActionNetwork::Import

  def self.resource
    'person'
  end

  def self.import!(group)
    existing_count = 0
    new_count = 0
    updated_count = 0
    next_uri = first_uri(synced_at: group.synced_at)

    logger.info "Api::ActionNetwork::People#import! from #{next_uri}"

    Person.transaction do
      while next_uri
        people, next_uri = request_resources_from_action_network(next_uri, group)

        people.each(&:sanitize_email_addresses)

        existing_people, new_people = partition(people)

        new_count += new_people.size
        existing_count += existing_count.size
        updated_count = update_resources(existing_people)

        new_people = associate_with_group(new_people, group)

        create new_people
      end
      logger.debug "Api::ActionNetwork::People#import! new: #{new_count} existing: #{existing_count} updated: #{updated_count}"
    end
  end

  def self.associate_with_group(new_people, group)
    new_people.each do |person|
      person.groups.push(group)
    end
  end
end
