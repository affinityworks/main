class Attendance < ApplicationRecord
  include Api::Identifiers
  has_paper_trail ignore: [:created_at, :updated_at]

  has_many :attendance_origins
  has_many :origins, through: :attendance_origins

  # Temporary attributes used for import from Action Network
  attr_accessor :event_uuid
  attr_accessor :person_uuid


  scope :attended, -> { where(attended: true) }
  scope :unsynced, -> { where(synced: false) }
  validates :person_id, uniqueness: { scope: :event_id }


  has_many :tickets
  belongs_to :person
  belongs_to :event

  has_many :email_addresses, through: :person
  has_many :phone_numbers, through: :person
  has_many :personal_addresses, through: :person

  def export(group)
    Api::ActionNetwork::Attendance.export!(self, group)
    self.update_attribute(:synced, true)
  end

  def send_to_att_event_action_network
    return if attended.nil?
    attendance = remote_attendance_exported
    attendance.export(attendance.event.group)
  end

  private

  def remote_attendance_exported
    attended ? send_to_action_network_att_event : send_to_action_network_no_att_event
  end

  def send_to_action_network_att_event
    event.attendance_event&.export_attendace(self)
  end

  def send_to_action_network_no_att_event
    event.no_attendance_event&.export_attendace(self)
  end

end
