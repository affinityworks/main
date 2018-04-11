class GoogleGroup < ApplicationRecord
  # ASSOCIATIONS
  belongs_to :group

  validates_presence_of %i[group_id group_key email url]
end
