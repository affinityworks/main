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

  def google_gsuite_key
    Rails.configuration.networks[snakecase_name]["google_gsuite_key"]
  end

  def google_gsuite_admin_email
    Rails.configuration.networks[snakecase_name]["google_gsuite_admin_email"]
  end

  def google_gsuite_email_base
    Rails.configuration.networks[snakecase_name]["google_gsuite_email_base"]
  end

  def snakecase_name
    name.downcase.split.join("_")
  end
end
