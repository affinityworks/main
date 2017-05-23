# Devise assumes each Person has a single `email` attribute/DB column in people table. OSDI data model has multiple email_addresses.
# The `email` attribute is used for authentication. The `email_addresses` association is for mailing list subscriptions, event attendances,
# etc., and never used for authentication. People may have a different`email` than their primary `email_address`. This isn't intuitive,
# but is the simplest compromise between OSDI and Devise.
class Person < ApplicationRecord
  include Api::Identifiers

  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:facebook]

  serialize :custom_fields, Hash
  serialize :ethnicities, Array
  serialize :languages_spoken, Array

  has_one :employer_address, class_name: 'EmployerAddress'

  has_many :email_addresses
  has_many :personal_addresses, class_name: 'PersonalAddress'
  has_many :phone_numbers
  has_many :profiles
  has_many :donations
  has_many :submissions
  has_many :attendances
  has_many :events, through: :attendances
  has_many :answers
  has_many :memberships
  has_many :groups, through: :memberships

  attr_accessor :attended_events_count #NOTE ROAR purpose

  scope :by_email, -> (email) do
    includes(:email_addresses).where(email_addresses: { address: email })
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
    primary_email_address
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
    phone_numbers.detect(&:primary?)&.number
  end

  def primary_phone_number=(number)
    phone_numbers.new(number: number, primary: true)
  end

  def attended_group_events(group)
    attendances.attended.includes(:event).where(event_id: group.events.pluck(:id))
  end

  def attended_group_events_count(group)
    attended_group_events(group).count
  end

  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if email = conditions.delete(:email)
      self.includes(:email_addresses).where(email_addresses: { address: email }).first
    else
      super(warden_conditions)
    end
  end

  def self.add_event_attended(people, current_group)
    people.each do |person|
      person.attended_events_count = person.attended_group_events_count(current_group)
    end
  end
end
