class Network < ApplicationRecord
  # ASSOCIATIONS
  has_many :network_memberships
  has_many :members, through: :network_memberships, source: 'group'

  # VALIDATIONS
  validates :name, uniqueness: true

  validate :name_unchanged
  def name_unchanged
    if name_changed? && persisted?
      errors.add(:name, "Changing a network's name is not permitted")
    end
  end
end
