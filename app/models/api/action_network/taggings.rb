module Api::ActionNetwork::Taggings
  extend Api::ActionNetwork::Import

  def self.resource
    'tagging'
  end

  def self.import!(tag_identifier, tag_name, group)
    next_uri = first_uri(tag_id: tag_identifier)

    logger.info "Api::ActionNetwork::Taggings#import! from #{next_uri}"

    while next_uri
      taggings, next_uri = request_resources_from_action_network(next_uri, group)

      taggings.each { |tagging| associate_person(tagging, tag_name, group) }
    end
  end

  def self.first_uri(params={})
    uri = "https://actionnetwork.org/api/v2/tags/#{params[:tag_id]}/taggings"

    add_uri_filter(uri, params[:synced_at])
  end

  def self.associate_person(tagging, tag_name, group)
    person = find_or_import_person(person_identifier(tagging), group)
    person.tag_list.push(tag_name) unless person.nil?
    #person.save #not needed because tag push saves
  end

  def self.find_or_import_person(person_uid, group)
    Person.any_identifier("action_network:#{person_uid}").first ||
      Api::ActionNetwork::Person.import!(person_uid, group)
  end

  def self.person_identifier(tagging)
    tagging['_links']['osdi:person']['href'].match(/.*\/people\/(?<person_id>.+)/)['person_id']
  end
end
