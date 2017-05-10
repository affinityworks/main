class Attendance < ApplicationRecord
  include Api::Identifiers

  # Temporary attributes used for import from Action Network
  attr_accessor :event_uuid
  attr_accessor :person_uuid

  scope :attended, -> () { where(attended: true) }

  has_many :tickets
  belongs_to :person
  belongs_to :event
end
