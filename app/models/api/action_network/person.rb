module Api::ActionNetwork::Person
  extend Api::ActionNetwork::Import

  def self.import!(uuid, group)
    request_single_resource_from_action_network(first_uri(uuid), group)
  end

  def self.representer_class
    Api::ActionNetwork::PersonRepresenter
  end

  def self.resource
    'person'
  end
end
