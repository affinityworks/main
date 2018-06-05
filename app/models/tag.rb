class Tag < ApplicationRecord
  include Api::Identifiers

  attr_accessor :identifiers

  scope :by_type, ->(type) { joins(:taggings).distinct.where('taggings.taggable_type = ?', type) }
  scope :type_event, -> { by_type('Event') }
  scope :type_membership, -> { by_type('Membership') }

  validates :name, uniqueness: true
  has_many :tag_origins
  has_many :taggings
end
