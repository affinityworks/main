class Membership < ApplicationRecord
  belongs_to :group
  belongs_to :person

  enum role: [:member, :organizer]

  scope :organizer, -> () { where(role: 'organizer') }
  scope :member, -> () { where(role: 'member') }
end
