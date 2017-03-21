class EmailAddress < ApplicationRecord
  ADDRESS_FORMAT = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i

  validates :address, uniqueness: { scope: :person_id }
  validates :address, presence: true
  validates :address, format: { with: ADDRESS_FORMAT, message: "'%{value}' does not match #{ADDRESS_FORMAT}" }

  belongs_to :person

  def valid_address_format?
    address.present? && address.match(ADDRESS_FORMAT)
  end
end
