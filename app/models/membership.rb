class Membership < ApplicationRecord
  belongs_to :group
  belongs_to :person

  validates :person_id, uniqueness: { scope: :group_id }
  enum role: [:member, :organizer]

  scope :organizer, -> () { where(role: 'organizer') }
  scope :member, -> () { where(role: 'member') }
end
