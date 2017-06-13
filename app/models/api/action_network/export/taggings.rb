module Api::ActionNetwork::Export::Taggings
  extend Api::ActionNetwork::Export

  def self.representer_class
    Api::ActionNetwork::Export::TaggingRepresenter
  end

  def self.resource
    'tagging'
  end

  def self.export!(group)
    Origin.action_network.tag_origins.each do |tag_origin|
      tag_origin.taggings.each do |tagging|
        person_identifier = tagging.taggable.identifier_id('action_network')
        if person_identifier
          export_uri = "https://actionnetwork.org/api/v2/tags/#{tag_origin.uid}/taggings"
          export_single_resource(tagging, group, export_uri)
        end
      end
    end
  end
end
