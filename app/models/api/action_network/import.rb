module Api::ActionNetwork::Import
  def partition(resources)
    resources.partition do |resource|
      action_network_identifier = resource.identifier('action_network')
      resource_class.any_identifier(action_network_identifier).exists?
    end
  end

  def request_resources_from_action_network(uri, group)
    retries ||= 0

    collection = collection_class.new
    client = representer_class.new(collection)
    client.get(uri: uri, as: 'application/json') do |request|
      request['OSDI-API-TOKEN'] = group.an_api_key
    end
    logger.debug "#{self.class.name}#import! resources: #{collection.resources.size} page: #{collection.page}"

    next_uri = client.links && client.links['next']&.href
    [collection.resources, next_uri]
  rescue => e
    logger.error e.inspect
    retry if (retries += 1) < 3
    [[], nil]
  end

  def request_single_resource_from_action_network(uri, group)
    retries ||= 0


    resource = resource_class.new
    client = representer_class.new(resource)
    client.get(uri: uri, as: 'application/json') do |request|
      request['OSDI-API-TOKEN'] = group.an_api_key
    end
    # we need something which also checks about a user with the same email.
    if Person.any_identifier(resource.identifier('action_network')).exists?
      update_single_resource(resource)
    elsif do_we_know_about_this_email(resource)
      merge_person_with_resource(resource)
    else
      create_single_resource(resource)
    end
    resource.groups.push(group) unless group.members.include?(resource)
  rescue => e
    logger.error e.inspect
    retry if (retries += 1) < 3
    nil
  end

  # Update all attributes for resources that already exist and have not been modified after import
  # We may want to do something different
  def update_resources(existing_resources)
    updated_count = 0
    existing_resources.each do |resource|
      updated_count += 1 if update_single_resource(resource)
    end

    updated_count
  end

  def update_single_resource(resource)
    old_resource = resource_class.outdated_existing(resource, 'action_network').first

    return unless old_resource

    merge_resources(old_resource, resource)
  end

  def merge_person_with_resource(resource)
    resource.email_addresses.each do |email_address_obj|
      old_person = Person.by_email(email_address_obj.address)
      unless old_person.empty?
        return merge_resources(old_person.first, resource)
      end
    end
  end

  def do_we_know_about_this_email(resource)
    answer = false

    resource.email_addresses.each do |email_address_obj|
      answer = true if EmailAddress.find_by_address(email_address_obj.address)
    end

    return answer
  end

  def merge_resources(old_resource, resource)
    attributes = resource.attributes
    attributes.delete_if { |_, v| v.nil? }

    old_resource.update_attributes! attributes

    old_resource.save!
  end

  def create_single_resource(resource)
    begin
      resource.tap(&:save!)
    rescue Exception => e
      logger.error resource
      logger.error e
      raise e
    end
  end

  def create(new_resources)
    new_resources.each do |resource|
      create_single_resource(resource)
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

  def first_uri(params={})
    uri = "https://actionnetwork.org/api/v2/#{resource.pluralize}#{'/' + params[:uuid] if params[:uuid]}"

    add_uri_filter(uri, params[:synced_at])
  end

  def logger
    Rails.logger
  end

  def add_uri_filter(uri, modified_date)
    return uri unless modified_date
    uri = URI.parse(uri)
    uri.query = "filter=modified_date gt '#{modified_date.strftime('%Y-%m-%dT%H:%M:%SZ')}'"
    uri.to_s
  end
end
