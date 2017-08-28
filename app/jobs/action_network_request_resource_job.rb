class ActionNetworkRequestResourceJob < ApplicationJob
  #extend Api::ActionNetwork
  #extend Api::ActionNetwork::Person
  queue_as :default

  def perform(uri, group)
    
    Api::ActionNetwork::Person.request_single_resource_from_action_network(uri, group) do |resource|
      person = Api::ActionNetwork::Person.after_import(resource, group)
    end
  end
end
