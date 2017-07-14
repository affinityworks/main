class Group < ApplicationRecord
  #has_paper_trail
  acts_as_taggable

  validates :an_api_key, uniqueness: true

  has_many :memberships, dependent: :destroy
  has_many :members, through: :memberships, source: :person
  #has_many :organizers, -> { where(role: 'organizer') },
  #                             :through => :memberships,
  #                             :source => :person
  
  #this doesn't seem right...
  has_many :attendances, through: :members
  has_many :affiliations, foreign_key: :group_id, class_name: 'Affiliation'
  has_many :affiliations_with, foreign_key: :affiliated_id, class_name: 'Affiliation'

  has_many :affiliates, through: :affiliations, source: 'affiliated'
  has_many :affiliated_with, through: :affiliations_with, source: 'group'

  has_many :sync_logs

  has_and_belongs_to_many :events, dependent: :destroy
  has_and_belongs_to_many :advocacy_campaigns
  has_and_belongs_to_many :canvassing_efforts
  has_and_belongs_to_many :petitions
  has_and_belongs_to_many :share_pages
  has_and_belongs_to_many :forms
  belongs_to :creator, class_name: "Person"
  belongs_to :modified_by, class_name: "Person"
  belongs_to :location, class_name: 'GroupAddress', foreign_key: :address_id


  def before_create
    self.modified_by = self.creator
  end

  def import_events
    Api::ActionNetwork::Events.import!(self)
  end

  def import_members
    Api::ActionNetwork::People.import!(self)
  end

  def import_tags
    Api::ActionNetwork::Tags.import!(self)
  end

  def import_attendances(event)
    Api::ActionNetwork::Attendances.import!(event, self)
  end

  def sync_with_action_network
      synced_time = Time.now
      events_logs = import_events
      members_logs = import_members

      attendances_logs = events.map do |event|
        import_attendances(event)
      end

      import_tags
      self.update_attribute(:synced_at, synced_time)
      self.sync_logs.create(
        data: {
          events: events_logs,
          members: members_logs,
          attendances: attendances_logs.compact.inject{|memo, el| memo.merge( el ){|k, old_v, new_v| old_v + new_v}}
        },
        origin: Origin.action_network
      )
  end

  def all_events
    groups_ids = affiliates.pluck(:id) << id
    Event.joins(:groups).where(groups: { id: groups_ids })
  end

  def all_memberships
    groups_ids = affiliates.pluck(:id) << id
    Membership.where(group_id: groups_ids)
  end

  def all_members
    Person.where(id: all_memberships.pluck(:person_id))
  end

  def upcoming_events
    events.upcoming
  end

  def has_affiliates
    affiliates.any?
  end

  def as_json(options={})
    super({
      only: [:name, :id],
      methods: :has_affiliates
    }.merge(options))
  end
end
