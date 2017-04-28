# Devise assumes each Person has a single `email` attribute/DB column in people table. OSDI data model has multiple email_addresses.
# The `email` attribute is used for authentication. The `email_addresses` association is for mailing list subscriptions, event attendances,
# etc., and never used for authentication. People may have a different`email` than their primary `email_address`. This isn't intuitive,
# but is the simplest compromise between OSDI and Devise.
class Person < ApplicationRecord
  include Api::Identifiers

  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable

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

  def name
    [ given_name, family_name ].compact.join(' ')
  end

  def primary_email_address
    email_addresses.detect(&:primary?)&.address
  end

  # Override Devise lib/devise/models/validatable.rb
  def email_required?
    password.present?
  end

  # Override Devise lib/devise/models/validatable.rb
  def password_required?
    email.present? && (!persisted? || !password.nil? || !password_confirmation.nil?)
  end

  def sanitize_email_addresses
    self.email_addresses = email_addresses.select(&:valid_address_format?)
  end

  def primary_phone_number
    phone_numbers.detect(&:primary?)&.number
  end
end
