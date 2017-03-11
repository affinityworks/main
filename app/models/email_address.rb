class EmailAddress < ApplicationRecord
  ADDRESS_FORMAT = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i

  # it will be possible to update email with a duplicated value
  validates :address, uniqueness: true, on: :create
  validates :address, presence: true
  validates :address, format: { with: ADDRESS_FORMAT }

  belongs_to :person

  def valid_address_format?
    address.present? && address.match(ADDRESS_FORMAT)
  end
end
