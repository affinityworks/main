module Api::ActionNetwork::Import
  def partition(resources)
    resources.partition do |resource|
      action_network_identifier = resource.identifier('action_network')
      resource_class.any_identifier(action_network_identifier).exists?
    end
  end

  def request_resources_from_action_network(uri)
    collection = collection_class.new
    client = representer_class.new(collection)
    client.get(uri: uri, as: 'application/json') do |request|
      request['OSDI-API-TOKEN'] = Rails.application.secrets.action_network_api_token
    end

    logger.debug "#{self.class.name}#import! resources: #{collection.resources.size} page: #{collection.page}"

    next_uri = client.links['next']&.href
    [collection.resources, next_uri]
  end

  def logger
    Rails.logger
  end
end
