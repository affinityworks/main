module Api::ActionNetwork::Tags
  extend Api::ActionNetwork::Import

  def self.resource
    'tag'
  end

  def self.import!(group)
    existing_count = 0
    new_count = 0
    updated_count = 0
    next_uri = first_uri

    logger.info "Api::ActionNetwork::Tags#import! from #{next_uri}"

    while next_uri
      tags, next_uri = request_resources_from_action_network(next_uri, group)

      tags.each do |tag|
        tag_identifier = tag.identifier_id('action_network')
        tag = Tag.find_or_create_by(name: tag.name)
        TagOrigin.create(tag: tag, uid: tag_identifier, origin: Origin.action_network)
        Api::ActionNetwork::Taggings.import!(tag_identifier, tag.name, group)
      end
    end
  end

  def partition(resources)
    resources.partition do |resource|
      action_network_identifier = resource.identifier('action_network')
      TagOrigin.action_network.exists?(uid: action_network_identifier)
    end
  end

  def self.import_taggings(tag, group)
    identifier = tag.identifier_id('action_network')
    next_uri = "https://actionnetwork.org/api/v2/tags/#{identifier}/taggings"
    while next_uri
      taggings, next_uri = request_resources_from_action_network(next_uri, group)
    end
  end
end
