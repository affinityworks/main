class TagOrigin < ApplicationRecord
  belongs_to :tag
  belongs_to :origin
  has_many :taggings, through: :tag

  validates :uid, presence: true
  validates_uniqueness_of :uid, scope: :origin
end
