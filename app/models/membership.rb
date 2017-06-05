class Membership < ApplicationRecord
  acts_as_taggable
  belongs_to :group
  belongs_to :person

  validates :person_id, uniqueness: { scope: :group_id }
  validates :group_id, uniqueness: { scope: :person_id }

  scope :any_organizer, -> () { where(role: ['organizer', 'national_organizer']) }

  enum role: [:member, :organizer, :national_organizer]
end
