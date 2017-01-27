class EmailAddress < ApplicationRecord

  # it will be possible to update email with a duplicated value
  validates :address, :uniqueness => true, :on => :create
  validates_presence_of :address
  validates :address, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, on: :create }

  belongs_to :person
end
