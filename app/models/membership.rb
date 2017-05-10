class Membership < ApplicationRecord
  belongs_to :group
  belongs_to :person

  enum role: [:member, :organizer]
end
