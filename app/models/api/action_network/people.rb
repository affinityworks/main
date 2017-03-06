class Api::ActionNetwork::People
  include Api::ActionNetwork::Collections

  attr_accessor :people

  # Import people from Action Network OSDI API.
  # Requires ACTION_NETWORK_API_TOKEN set in ENV.
  # There are no external endpoints for this method yet.
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
    action_network = Api::ActionNetwork::People.new
    client = Api::Collections::PeopleRepresenter.new(action_network)
    client.get(uri: 'https://actionnetwork.org/api/v2/people', as: 'application/json') do |request|
      request['OSDI-API-TOKEN'] = Rails.application.secrets.action_network_api_token
    end

    logger.debug "Api::ActionNetwork::People#import! people: #{action_network.people.size}"
    action_network.people
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

      if old_person
        updated_count += 1
        attributes = person.attributes
        attributes.delete_if { |k, v| v.nil? }
        old_person.update_attributes! attributes
      end
    end

    updated_count
  end

  def self.logger
    Person.logger
  end
end
