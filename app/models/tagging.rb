class Tagging < ApplicationRecord
  belongs_to :tag, optional: true
  belongs_to :taggable, polymorphic: true, optional: true

  def self.export(group)
    Api::ActionNetwork::Export::Taggings.export!(group)
  end
end
