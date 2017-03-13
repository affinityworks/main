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

    next_uri = client.links && client.links['next']&.href
    [collection.resources, next_uri]
  end

  # Update all attributes for resources that already exist and have not been modified after import
  # We may want to do something different
  def update_resources(existing_resources)
    updated_count = 0
    existing_resources.each do |resource|
      old_resource = resource_class.outdated_existing(resource, 'action_network').first

      next unless old_resource

      updated_count += 1
      attributes = resource.attributes
      attributes.delete_if { |_, v| v.nil? }
      old_resource.update_attributes! attributes
    end

    updated_count
  end

  def create(new_resources)
    new_resources.each do |resource|
      begin
        resource.save!
      rescue StandardError => e
        logger.error resource
        raise e
      end
    end
  end

  # Example: People
  def plural_resource
    resource.classify.pluralize
  end

  # Example: ::Person
  def resource_class
    "::#{resource.classify}".safe_constantize
  end

  # Example: Api::Collections::People
  def collection_class
    "Api::Collections::#{plural_resource}".safe_constantize
  end

  # Example: Api::Collections::PeopleRepresenter
  def representer_class
    "Api::Collections::#{plural_resource}Representer".safe_constantize
  end

  def first_uri
    "https://actionnetwork.org/api/v2/#{resource.pluralize}"
  end

  def logger
    Rails.logger
  end
end
