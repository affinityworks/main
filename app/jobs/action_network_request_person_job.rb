
class ActionNetworkRequestPersonJob < ApplicationJob
  queue_as :default

  def perform(next_uri,group)
    puts "in perform #{next_uri}"
    logs = []
    people, next_uri = Api::ActionNetwork::People.request_resources_from_action_network(next_uri, group)
    people.each(&:sanitize_email_addresses)
    people.each do |new_person|
      logs << Api::ActionNetwork::Person.after_import(new_person, group)
    end

    ActionNetworkRequestPersonJob.perform_later(next_uri, group) if (next_uri && group)
  end
end
