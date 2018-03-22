class NetworkMembership < ApplicationRecord
  # ASSOCIATIONS
  belongs_to :group
  belongs_to :network

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
