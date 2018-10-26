class NetworkMembership < ApplicationRecord
  # ASSOCIATIONS
  belongs_to :group, optional: true
  belongs_to :network, optional: true

  # SCOPES
  scope :primary, ->{ where(primary: true) }

  # VALIDATIONS
  validates :group_id, uniqueness: {
              scope: :network_id,
              message: 'only one membership per network permitted'
            }

  validates :primary, uniqueness: {
              scope: :group_id,
              message: 'only one primary network per group permitted'
            }
end
