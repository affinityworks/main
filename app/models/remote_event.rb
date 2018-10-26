class RemoteEvent < ApplicationRecord
  belongs_to :event, optional: true

  has_paper_trail

  validates :event_id, presence: true
  validates :name, presence: true
  validates :uid, presence: true, uniqueness: { scope: :type }
end
