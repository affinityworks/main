module Api::ActionNetwork::Person
  def self.import!(uuid, group)
    person = Person.new
    client = Api::ActionNetwork::PersonRepresenter.new(person)
    client.get(uri: uri(uuid), as: 'application/json') do |request|
      request['OSDI-API-TOKEN'] = group.an_api_key
    end

    if Person.any_identifier(person.identifier('action_network')).exists?
      update_resource(person.identifier('action_network'), person.attributes)
    else
      create_new_person(person, group)
    end
  end

  def self.uri(uuid)
    "https://actionnetwork.org/api/v2/people/#{uuid}"
  end

  def self.create_new_person(person, group)
    person.groups.push(group)
    person.save
    person
  end

  def self.update_resource(action_network_id, new_attributes)
    person = Person.any_identifier(action_network_id).first
    new_attributes.delete_if { |_, v| v.nil? }
    person.update_attributes(new_attributes)
    person
  end
end
