class Attendance < ApplicationRecord
  include Api::Identifiers

  # Temporary attributes used for import from Action Network
  attr_accessor :event_uuid
  attr_accessor :person_uuid

  scope :attended, -> () { where(attended: true) }
  validates :person_id, uniqueness: { scope: :event_id }

  has_many :tickets
  belongs_to :person
  belongs_to :event
end
