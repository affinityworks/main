module Api::ActionNetwork::People
  extend Api::ActionNetwork::Import

  def self.resource_class
    Person
  end

  def self.collection_class
    Api::Collections::People
  end

  def self.representer_class
    Api::Collections::PeopleRepresenter
  end

  def self.import!
    existing_count = 0
    new_count = 0
    updated_count = 0
    next_uri = 'https://actionnetwork.org/api/v2/people'

    logger.info "Api::ActionNetwork::People#import! from #{next_uri}"

    Person.transaction do
      while next_uri
        people, next_uri = request_resources_from_action_network(next_uri)

        people.each(&:sanitize_email_addresses)

        existing_people, new_people = partition(people)

        new_count += new_people.size
        existing_count += existing_count.size
        updated_count = update_people(existing_people)

        create new_people
      end
      logger.debug "Api::ActionNetwork::People#import! new: #{new_count} existing: #{existing_count} updated: #{updated_count}"
    end
  end

  # Update all attributes for people that already exist and have not been modified after import
  # We may want to do something different
  def self.update_people(existing_people)
    updated_count = 0
    existing_people.each do |person|
      old_person = Person.outdated_existing(person, 'action_network').first

      next unless old_person

      updated_count += 1
      attributes = person.attributes
      attributes.delete_if { |_, v| v.nil? }
      old_person.update_attributes! attributes
    end

    updated_count
  end

  def self.create(new_people)
    new_people.each do |person|
      begin
        person.save!
      rescue StandardError => e
        logger.error person
        raise e
      end
    end
  end
end
