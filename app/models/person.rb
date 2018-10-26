# == Schema Information
#
# Table name: people
#
#  id                     :integer          not null, primary key
#  array                  :string
#  family_name            :string
#  given_name             :string
#  additional_name        :string
#  honorific_prefix       :string
#  honorific_suffix       :string
#  gender                 :string
#  gender_identity        :string
#  party_identification   :string
#  source                 :string
#  ethnicities            :string
#  languages_spoken       :string
#  birthdate              :date
#  employer               :string
#  custom_fields          :text
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  identifiers            :text             default([]), is an Array
#  admin                  :boolean          default(FALSE)
#  synced                 :boolean          default(TRUE)
#  attendances_count      :integer          default(0)
#

# Devise assumes each Person has a single `email` attribute/DB column in people table. OSDI data model has multiple email_addresses.
# The `email` attribute is used for authentication. The `email_addresses` association is for mailing list subscriptions, event attendances,
# etc., and never used for authentication. People may have a different`email` than their primary `email_address`. This isn't intuitive,
# but is the simplest compromise between OSDI and Devise.
class Person < ApplicationRecord
  include Api::Identifiers
  include ArelHelpers::ArelTable
  include CanSignup

  acts_as_taggable
  has_paper_trail ignore: [:created_at, :updated_at]

  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable,
         :registerable,
         :omniauthable, omniauth_providers: [:facebook, :google_oauth2]

  serialize :custom_fields, Hash
  serialize :ethnicities, Array
  serialize :languages_spoken, Array

  has_one :employer_address, class_name: 'EmployerAddress'

  has_many :email_addresses, dependent: :destroy
  has_many :identities, dependent: :destroy
  has_many :personal_addresses, class_name: 'PersonalAddress'
  has_many :phone_numbers, dependent: :destroy
  has_many :profiles, dependent: :destroy
  has_many :donations, dependent: :destroy
  has_many :submissions, dependent: :destroy
  has_many :attendances, dependent: :destroy
  has_many :events, through: :attendances
  has_many :memberships, dependent: :destroy
  has_many :groups, through: :memberships

  accepts_nested_attributes_for :email_addresses, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :phone_numbers, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :memberships, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :personal_addresses, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :identities, reject_if: :all_blank, allow_destroy: true

  # TODO: (aguestuser|28-Feb-2018) fix `membership` typos
  has_many :organizer_memberships, -> { organizer }, :class_name => 'Membership'
  has_many :organized_groups, :source => :group, :through => :organizer_memberships

  attr_accessor :attended_events_count #NOTE ROAR purpose

  after_create :custom_field_to_phone_number

  scope :by_email, -> (email) do
    includes(:email_addresses).where(email_addresses: { address: email })
  end

  scope :unsynced, -> { where(synced: false) }
  scope :family_name_like, ->(family_name) { where('family_name ILIKE ?', "%#{family_name}%") }

  #validates_inclusion_of :gender, :in => :gender_options
  serialize :languages_spoken, Array
  serialize :ethnicities, Array

  delegate :can?, :cannot?, :to => :ability

  def ability
    @ability ||= Ability.new(self)
  end

  def gender_options
    ["Other", "Male", "Female"]
  end

  def name
    [ given_name, family_name ].compact.join(' ')
  end

  def primary_email_address
    email_addresses.detect(&:primary?)&.address
  end

  def primary_email_address=(email)
    email_addresses.new(address: email, primary: true)
  end

  def primary_personal_address
    personal_addresses.detect(&:primary?)
  end

  def primary_personal_address=(attributes)
    personal_addresses.new(attributes.merge(primary: true))
  end

  def email
    primary_email_address || email_addresses.first&.address
  end

  #i'm not really sure if this is needed but devise was failing without it.
  # this is a bit of a hack. --rabble
  def email=(email_address)
    return false unless email_addresses.detect(&:primary?)
    email_addresses.detect(&:primary?).address=(email_address)
  end

  # Override Devise lib/devise/models/validatable.rb
  def email_required?
    false
  end

  # Override Devise lib/devise/models/validatable.rb
  def password_required?
    false
  end

  # Override Devise lib/devise/models/validatable.rb
  def email_changed?
    false
  end

  def sanitize_email_addresses
    self.email_addresses = email_addresses.select(&:valid_address_format?)
  end

  def primary_phone_number
    phone_number = phone_numbers.detect(&:primary?)&.number

    if phone_numbers.any?
      phone_number = phone_numbers.first.number unless phone_number
    end

    return phone_number || ''
  end

  def primary_phone_number=(number)
    return unless number.present?
    phone_numbers.new(number: number, primary: true)
  end

  def attended_group_events(group)
    attendances.attended.includes(:event).where(event_id: group.events.pluck(:id))
  end

  def attended_group_events_count(group)
    attended_group_events(group).count
  end

  def as_json(options={})
    super.merge!({
      linked_with_facebook: identities.facebook.any?
    }) #NOTE Change if other OAuth provider is added
  end

  def export(group)
    Api::ActionNetwork::Person.export!(self, group)
    self.update_attribute(:synced, true)
  end

  def json_representation
    JsonApi::PersonRepresenter.new(self)
  end

  # PREDICATES

  def is_member_of?(group)
    group.members.include?(self)
  end

  def missing_contact_info?
    primary_personal_address&.postal_code.nil?
  end

  def has_contact_info?
    !missing_contact_info?
  end

  #
  # CLASS METHODS
  #

  class << self
    def find_by_email(email)
      includes(:email_addresses).where(email_addresses: { address: email }).first
    end

    def find_first_by_auth_conditions(warden_conditions)
      conditions = warden_conditions.dup
      if email = conditions.delete(:email)
        find_by_email(email)
      else
        super(warden_conditions)
      end
    end

    def find_by_email_param(person_params)
      find_by_email(person_params.dig('email_addresses_attributes', '0', 'address'))
    end

    def build_from_oauth_signup(auth, person_params={})
      from_oauth_signup :new, auth, person_params
    end

    def create_from_oauth_signup(auth, person_params={})
      from_oauth_signup :create, auth, person_params
    end

    def from_oauth_signup(constructor, auth, person_params={})
      email, given, family = parse_info_from_auth(auth)
      return unless email
      # TODO (aguestuser|09 May 2018): consider rewriting this for clarity
      send constructor, signup_attrs(auth, person_params, email, given, family)
    end

    def from_oauth_login(auth, signed_in_resource = nil)
      email = auth.info.email
      return unless email

      email = EmailAddress.find_by(address: email)
      return unless email

      identity = Identity.find_for_oauth(auth)
      person = signed_in_resource || email.person

      omniauth_signed_in_resource(email, identity, person)
    end

    def add_event_attended(people, current_group)
      people.each do |person|
        person.attended_events_count = person.attended_group_events_count(current_group)
      end
    end

    def map_with_remote_rsvps(remote_rsvps)
      all.each.with_object([]) do |person, mapping|
        matches, remote_rsvps = remote_rsvps.partition do |rsvp|
          rsvp['name'].include?(person.given_name) &&
            rsvp['name'].include?(person.family_name)
        end

        mapping << { fb_rsvp: matches.first, person: person.json_representation } if matches.any?
      end
    end

    def unmatched_remote_rsvps(remote_rsvps)
      remote_rsvps.delete_if { |rsvp| all.collect(&:name).include?(rsvp['name']) }
    end

    def import_remote(remote_people, group, event, member_id)
      remote_people.each do |remote_person|
        name_array = remote_person[:name].split(' ')
        family_name = name_array.pop
        given_name = name_array.join(' ')

        person = Person.by_email(remote_person[:email]).first if remote_person[:email]
        person ||= Person.new(synced: false, given_name: given_name,
                              family_name: family_name
                             )

        person.email_addresses.find_or_initialize_by(address: remote_person[:email]) if remote_person[:email]

        person.add_identifier('facebook', remote_person[:id])
        person.memberships.find_or_initialize_by(group_id: group.id)
        person.attendances.find_or_initialize_by(event_id: event.id).tap do |attendance|
          attendance.origins.push(Origin.facebook)
          attendance.invited_by_id ||= member_id
          attendance.status ||= 'accepted'
        end
        person.save
      end
    end # import_remote
  end # CLASS METHODS

  #
  # MUTATIONS
  #

  def update_from_oauth_signup(auth, person_params={})
    Person.save_omniauth(EmailAddress.find_by(address: auth.info.email),
                         Identity.find_for_oauth(auth),
                         self.tap{ |p| p.update!(person_params) })
  end

  #we dont' use permitted but do use rejected
  def permitted_import_parameters
    return [:family_name, :given_name, :additional_name, :honorific_prefix,
            :honorific_suffix, :gender, :gender_identity, :party_identification,
            :primary_email_address, :primary_phone_number, :person, :email_address, :phone_number,
            :source, {:ethnicities => []}, {:languages_spoken => []}, :birthdate, :employer,
            {:custom_fields => {}}, :created_at, :updated_at]
  end

  def rejected_import_parameters
    return [:encrypted_password]
  end


  def custom_field_to_phone_number
    potential_fields = [ 'Phone Number', 'Phone', 'phone', "2 Phone"]

    potential_fields.each do |field_name|
      unless custom_fields[field_name].nil?
        phone_numbers.create(:number => custom_fields[field_name])
      end
    end
  end

  def role_in_group(group)
    memberships.find_by(group: group)&.role
  end

  def build_contact_info
    %i[personal_addresses email_addresses phone_numbers].each do |x|
      send(x).build(primary: true) if send(x).empty?
    end
    self
  end

  private

  class << self

    #
    # OAUTH SIGNUP HELPERS
    #

    def signup_attrs(auth, person_params, email, given, family)
      person_params.merge(
        given_name: given,
        family_name: family,
        email_addresses: [EmailAddress.new(address: email, primary: true)],
        identities: [Identity.find_for_oauth(auth)],
      )
    end

    def parse_info_from_auth(auth)
      email = auth.info.email
      given, _, family = auth.info.name.partition(" ")
      [email, given, family]
    end

    #
    # OAUTH LOGIN HELPERS
    #

    def omniauth_signed_in_resource(email, identity, person)
      return nil if email.person != person
      return nil if identity.persisted? && identity.person != person
      return nil if email.new_record? && person.nil?
      save_omniauth(email, identity, person)
    end

    def save_omniauth(email, identity, person)
      person.email_addresses << email if email.new_record?
      person.identities << identity if identity.new_record?
      person.save if email.new_record? || identity.new_record?
      person
    end
  end
end
