class Tagging < ApplicationRecord
  belongs_to :tag
  belongs_to :taggable, polymorphic: true

  def self.export(group)
    Api::ActionNetwork::Export::Taggings.export!(group)
  end
end
