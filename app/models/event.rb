class Event < ApplicationRecord
  include Api::Identifiers

  has_paper_trail ignore: [:created_at, :updated_at]
  acts_as_taggable

  default_scope { where.not(status: 'cancelled') }

  attr_accessor :attended_count
  attr_accessor :rsvp_count

  UPCOMING_EVENTS_DAYS = 90

  scope :upcoming, ->() { where('start_date BETWEEN ? AND ?', Date.today, Date.today + UPCOMING_EVENTS_DAYS.days) }
  scope :start, ->(start) { where("DATE(start_date) = ?", start) }

  has_many :ticket_levels#, dependent: :destroy

  belongs_to :location, class_name: 'Address', foreign_key: :address_id
  belongs_to :creator, class_name: 'Person'
  belongs_to :organizer, class_name: 'Person'
  belongs_to :modified_by, class_name: 'Person'
  has_many :attendances, dependent: :destroy
  has_many :attendees, through: :attendances, source: :person
  has_many :reminders, dependent: :destroy
  has_and_belongs_to_many :groups
  has_many :facebook_events, dependent: :destroy

  #My suspicion is that it's better to do this in sql and not sore all this in memory
  def self.add_attendance_counts(events)
    rsvps = Attendance.group(:event_id, :status).count
    attendances = Attendance.group(:event_id, :attended).count
    events.each do |event|
      event.rsvp_count = [rsvps[[event.id, 'accepted']], rsvps[[event.id, 'tentative']]].compact.sum
      event.attended_count = attendances[[event.id, true]] || 0
    end
  end

  def self.sort_by_date(direction)
    order(start_date: direction)
  end

  def self.activity_feed(group, date=Date.today-1.days)
    events = group.all_events.where(updated_at: date.beginning_of_day...Date.today.end_of_day)
    {}.tap do |feed|
      created, updated = events.partition { |event| event.updated_at == event.created_at }
      feed[:created] = created.map(&:to_activity_json)
      feed[:updated] = updated.map(&:to_activity_json)
    end
  end

  def group #TODO Change relation to 1 to Many
    groups.first
  end

  def to_activity_json
    as_json(only: [:title, :id, :created_at, :updated_at], include: { group: { only:[:name] } })
  end
end
