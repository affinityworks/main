class TagOrigin < ApplicationRecord
  belongs_to :tag, optional: true
  belongs_to :origin, optional: true
  has_many :taggings, through: :tag

  validates :uid, presence: true
  validates_uniqueness_of :uid, scope: :origin
end
