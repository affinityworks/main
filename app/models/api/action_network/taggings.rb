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
    if person.nil?
      logger.debug("Failed to find person for #{tagging}")
    elsif person.class == ActionNetworkRequestResourceJob
      logger.debug("triggered person import for #{tagging}")
    else
      #we should update this to a cleaner non-depricated way of loading
      membership = person.memberships(:group => group).first
      unless membership.nil?
        membership.tag_list.add(tag_name)
        membership.save
      end
    end
  end

  def self.find_or_import_person(person_uid, group)
    Person.any_identifier("action_network:#{person_uid}").first ||
      Api::ActionNetwork::Person.import!(person_uid, group)
  end

  def self.person_identifier(tagging)
    tagging['_links']['osdi:person']['href'].match(/.*\/people\/(?<person_id>.+)/)['person_id']
  end
end
