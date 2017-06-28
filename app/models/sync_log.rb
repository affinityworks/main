class SyncLog < ApplicationRecord
  belongs_to :group
  belongs_to :origin
end
