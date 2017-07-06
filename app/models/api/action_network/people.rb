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

    logs = []

    #::Person.transaction do
      while next_uri
        people, next_uri = request_resources_from_action_network(next_uri, group)

        people.each(&:sanitize_email_addresses)

        existing_people, new_people = partition(people)

        new_count += new_people.size
        existing_count += existing_count.size

        people.each do |new_person|
          logs << Api::ActionNetwork::Person.after_import(new_person, group)
        end
      end
      logger.debug "Api::ActionNetwork::People#import! new: #{new_count} existing: #{existing_count} updated: #{updated_count}"
    #end

    {
      created: logs.map { |log| log[:created] || 0 }.sum,
      updated: logs.map { |log| log[:updated] || 0 }.sum,
      errors: logs.map { |log| log[:errors] || 0 }.sum
    }
  end

  def self.errors_count
    0
  end
end
