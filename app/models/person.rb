# Devise assumes each Person has a single `email` attribute/DB column in people table.
# OSDI data model has multiple email_addresses.
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

  validate :name_or_email
  validate :email_matches_primary_email_address

  # Need to check against #email before save, so can't use `belongs_to`
  def primary_email_address
    email_addresses.detect(&:primary?)&.address
  end

  def name_or_email
    if given_name.blank? && family_name.blank? && email.blank?
      errors.add :email, 'and given_name and family_name cannot be blank'
    end
  end

  def email_matches_primary_email_address
    if email.present? && primary_email_address.present? && email != primary_email_address
      errors.add :email, "'#{email}' must match primary email_addresses '#{primary_email_address}'"
    end
  end

  # Override Devise lib/devise/models/validatable.rb
  def email_required?
    password.present?
  end

  # Override Devise lib/devise/models/validatable.rb
  def password_required?
    email.present? && (!persisted? || !password.nil? || !password_confirmation.nil?)
  end
end
