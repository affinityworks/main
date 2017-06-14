class Membership < ApplicationRecord
  acts_as_taggable
  belongs_to :group
  belongs_to :person
  has_many :notes, as: :notable

  validates :person_id, uniqueness: { scope: :group_id }
  validates :group_id, uniqueness: { scope: :person_id }

  enum role: [:member, :organizer]
end
