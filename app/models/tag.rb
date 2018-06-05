class Tag < ApplicationRecord
  include Api::Identifiers

  attr_accessor :identifiers

  scope :by_type, ->(type) { joins(:taggings).distinct.where('taggings.taggable_type = ?', type) }
  scope :by_type_and_ids, ->(type, ids) { joins(:taggings).distinct.where('taggings.taggable_type = ? AND taggings.taggable_id IN (?)', type, ids) }
  scope :type_event, -> { by_type('Event') }
  scope :type_membership, -> { by_type('Membership') }
  scope :type_membership_with_ids, ->(ids) { by_type_and_ids('Membership', ids) }

  validates :name, uniqueness: true
  has_many :tag_origins
  has_many :taggings
end
