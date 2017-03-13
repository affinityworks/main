module Api::ActionNetwork::People
  extend Api::ActionNetwork::Import

  def self.import!
    existing_count = 0
    new_count = 0
    updated_count = 0
    next_uri = 'https://actionnetwork.org/api/v2/people'

    logger.info "Api::ActionNetwork::People#import! from #{next_uri}"

    Person.transaction do
      while next_uri
        people, next_uri = request_people_from_action_network(next_uri)

        people.each(&:sanitize_email_addresses)

        existing_people, new_people = partition_people(people)

        new_count += new_people.size
        existing_count += existing_count.size
        updated_count = update_people(existing_people)

        create new_people
      end
      logger.debug "Api::ActionNetwork::People#import! new: #{new_count} existing: #{existing_count} updated: #{updated_count}"
    end
  end

  def self.request_people_from_action_network(uri)
    collection = Api::Collections::People.new
    client = Api::Collections::PeopleRepresenter.new(collection)
    client.get(uri: uri, as: 'application/json') do |request|
      request['OSDI-API-TOKEN'] = Rails.application.secrets.action_network_api_token
    end

    logger.debug "Api::ActionNetwork::People#import! people: #{collection.people.size} page: #{collection.page}"

    next_uri = client.links['next']&.href
    [collection.people, next_uri]
  end

  def self.partition_people(people)
    people.partition do |person|
      action_network_identifier = person.identifiers.detect { |identifier| identifier['action_network:'] }
      Person.any_identifier(action_network_identifier).exists?
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
