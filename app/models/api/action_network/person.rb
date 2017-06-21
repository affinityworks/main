module Api::ActionNetwork::Person
  extend Api::ActionNetwork::Import
  extend Api::ActionNetwork::Export

  def self.import!(uuid, group)
    request_single_resource_from_action_network(first_uri(uuid: uuid), group) do |resource|
      after_import(resource, group)
    end
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

  def self.after_import(resource, group)

    person = Person.any_identifier(resource.identifier('action_network')).first
    logger.debug "#{self.class.name}#after_import! resource: #{resource} person: #{person}, :group #{group}"

    if !person.nil?
      update_single_resource(resource)

      Membership.create!(:person => person, :group => group, :role => 'member') unless group.members.include?(person)

    elsif do_we_know_about_this_email(resource)
      resource = merge_person_with_resource(resource)
    else
      resource = create_single_resource(resource)
    end

    resource.groups.push(group) unless group.members.include?(resource)
  end

  def self.merge_person_with_resource(resource)
    resource.email_addresses.each do |email_address_obj|
      old_person = Person.by_email(email_address_obj.address)
      unless old_person.empty?
        return merge_resources(old_person.first, resource)
      end
    end
  end

  def self.do_we_know_about_this_email(resource)
    resource.email_addresses.any? do |email_address_obj|
      EmailAddress.find_by_address(email_address_obj.address)
    end
  end
end
