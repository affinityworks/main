class Event < ApplicationRecord
  include Api::Identifiers

  attr_accessor :attended_count
  attr_accessor :invited_count
  attr_accessor :rsvp_count

  has_many :ticket_levels

  belongs_to :location, class_name: 'Address', foreign_key: :address_id
  belongs_to :creator, class_name: 'Person'
  belongs_to :organizer, class_name: 'Person'
  belongs_to :modified_by, class_name: 'Person'
  has_many :attendances
  has_many :reminders

  def self.add_attendance_counts(events)
    attendances = Attendance.group(:event_id, :status).count
    events.each do |event|
      event.rsvp_count = [attendances[[event.id, 'accepted']], attendances[[event.id, 'tentative']]].compact.sum
      event.attended_count = attendances[[event.id, 'attended']] || 0
      event.invited_count = event.rsvp_count + event.attended_count
    end
  end
end
