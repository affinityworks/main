class Api::ActionNetwork::People
  def self.import!
    logger.info 'Api::ActionNetwork::People#import! from https://actionnetwork.org/api/v2/people'

    people = request_people_from_action_network

    Person.transaction do
      existing_people, new_people = partition_people(people)
      updated_count = update_people(existing_people)
      logger.debug "Api::ActionNetwork::People#import! new: #{new_people.size} existing: #{existing_people.size} updated: #{updated_count}"
      new_people.each(&:save!)
    end
  end

  def self.request_people_from_action_network
    collection = Api::Collections::People.new
    client = Api::Collections::PeopleRepresenter.new(collection)
    client.get(uri: 'https://actionnetwork.org/api/v2/people', as: 'application/json') do |request|
      request['OSDI-API-TOKEN'] = Rails.application.secrets.action_network_api_token
    end

    logger.debug "Api::ActionNetwork::People#import! people: #{collection.people.size}"
    collection.people
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

  def self.logger
    Person.logger
  end
end
