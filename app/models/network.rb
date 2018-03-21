class Network < ApplicationRecord
  # ASSOCIATIONS
  has_many :network_memberships
  has_many :members, through: :network_memberships, source: 'group'

  # VALIDATIONS
  validates :name, uniqueness: true
end
