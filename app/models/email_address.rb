# == Schema Information
#
# Table name: email_addresses
#
#  id           :integer          not null, primary key
#  primary      :boolean
#  address      :string
#  address_type :string
#  status       :string
#  person_id    :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class EmailAddress < ApplicationRecord
  has_paper_trail

  ADDRESS_FORMAT = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i

  validates :address, uniqueness: true
  validates :address, presence: true
  validates :address,
            format: { with: ADDRESS_FORMAT,
                      message: "'%{value}' is not a valid email address" }

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
