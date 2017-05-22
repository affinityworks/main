class Attendance < ApplicationRecord
  include Api::Identifiers

  # Temporary attributes used for import from Action Network
  attr_accessor :event_uuid
  attr_accessor :person_uuid

  scope :attended, -> { where(attended: true) }
  scope :unsynced, -> { where(synced: false) }

  has_many :tickets
  belongs_to :person
  belongs_to :event

  def export(group)
    Api::ActionNetwork::Attendance.export!(self, group)
    self.update_attribute(:synced, true)
  end
end
