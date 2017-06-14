class Tag < ApplicationRecord
  include Api::Identifiers

  attr_accessor :identifiers

  validates :name, uniqueness: true
  has_many :tag_origins
  has_many :taggings
end
