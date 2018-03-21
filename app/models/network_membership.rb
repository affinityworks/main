class NetworkMembership < ApplicationRecord
  # ASSOCIATIONS
  belongs_to :group
  belongs_to :network

  # SCOPES
  scope :primary, ->{ where(primary: true) }

  # VALIDATIONS
  # TODO: index group_id:newtork_id (compound) if this is ever slow
  validates :group_id, uniqueness: {
              scope: :network_id,
              message: 'only one membership per network permitted'
            }

  # TODO: index `primary`` if this is ever slow
  validates :primary, uniqueness: {
              scope: :group_id,
              message: 'only one primary network per group permitted'
            }
end
