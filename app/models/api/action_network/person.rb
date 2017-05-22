module Api::ActionNetwork::Person
  extend Api::ActionNetwork::Import
  extend Api::ActionNetwork::Export

  def self.import!(uuid, group)
    request_single_resource_from_action_network(first_uri(uuid: uuid), group)
  end

  def self.export!(person, group)
    export_single_resource(person, group, export_uri)
  end

  def self.representer_class
    Api::ActionNetwork::PersonRepresenter
  end

  def self.resource
    'person'
  end

  def self.export_uri
    "https://actionnetwork.org/api/v2/#{resource.pluralize}"
  end
end
