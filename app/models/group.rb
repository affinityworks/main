class Group < ApplicationRecord
  has_many :memberships
  has_many :members, through: :memberships, source: :person
  has_many :attendances, through: :members

  has_and_belongs_to_many :events
  has_and_belongs_to_many :advocacy_campaigns
  has_and_belongs_to_many :canvassing_efforts
  has_and_belongs_to_many :petitions
  has_and_belongs_to_many :share_pages
  has_and_belongs_to_many :forms
  belongs_to :creator, class_name: "Person"
  belongs_to :modified_by, class_name: "Person"

  def before_create
    self.modified_by = self.creator
  end

  def import_events
    Api::ActionNetwork::Events.import!(self)
  end

  def import_members
    Api::ActionNetwork::People.import!(self)
  end

  def import_attendances(event)
    Api::ActionNetwork::Attendances.import!(event, self)
  end

  def sync_with_action_network
    Group.transaction do
      synced_time = Time.now
      import_events
      import_members
      events.each { |event| import_attendances(event) }
      self.update_attribute(:synced_at, synced_time)
    end
  end

  def upcoming_events
    events.upcoming
  end
end
