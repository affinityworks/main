class Group < ApplicationRecord
  include ArelHelpers::ArelTable
  #has_paper_trail
  acts_as_taggable

  validates :an_api_key, uniqueness: true, allow_nil: true

  has_many :memberships, dependent: :destroy
  has_many :members, through: :memberships, source: :person

  has_many :member_memberships, -> { member }, :class_name => 'Membership'
  has_many :member_members, through: :member_memberships, source: :person

  has_many :organizer_memerships, -> { organizer }, :class_name => 'Membership'
  has_many :organizers, :source => :person, :through => :organizer_memerships

  has_many :volunteer_memerships, -> { volunteer }, :class_name => 'Membership'
  has_many :volunteers, :source => :person, :through => :volunteer_memerships

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

  accepts_nested_attributes_for :location

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

  def member?(person)
    member_members.include?(person)
  end

  def volunteer?(person)
    volunteers.include?(person)
  end

  def affiliated_with_role(person, role)
    affiliated_with.joins(:memberships)
                   .where('person_id = ? and role = ?', person.id, role).take
  end

  def affiliates_with_role(person, role)
    affiliates.joins(:memberships)
              .where('person_id = ? and role = ?', person.id, role).take
  end

  def affiliation_with_role(person, role)
    affiliated_with_role(person, role) || affiliates_with_role(person, role)
  end


end
