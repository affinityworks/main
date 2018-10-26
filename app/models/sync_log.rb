class SyncLog < ApplicationRecord
  belongs_to :group, optional: true
  belongs_to :origin, optional: true
end
