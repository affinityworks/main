class EmailAddress < ApplicationRecord
  has_paper_trail

  ADDRESS_FORMAT = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  FORMAT = {with: ADDRESS_FORMAT, message: "'%{value}' does not match #{ADDRESS_FORMAT}" }

  validates :address, uniqueness: true
  validates :address, presence: true
  validates :address, format: FORMAT, if: :validate_address

  attr_accessor :validate_address

  belongs_to :person

  before_save :update_person_identifier

  def valid_address_format?
    address.present? && address.match(ADDRESS_FORMAT)
  end

  private

  def update_person_identifier
    if address_changed? && primary?
      hashed_address = Digest::SHA256.base64digest address
      self.person.add_identifier('affinity_id', hashed_address) if self.person
    end
  end
end
