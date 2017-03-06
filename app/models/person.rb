class Person < ApplicationRecord
  include Api::Identifiers

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable

  serialize :custom_fields, Hash
  serialize :ethnicities, Array
  serialize :languages_spoken, Array

  has_one :email_address
  has_one :employer_address, class_name: 'EmployerAddress'

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
  #has_many :memberships

  def email_addresses
    Array.wrap email_address
  end

  def name_or_email
    if given_name.blank? && family_name.blank? && email.blank?
      errors.add :email, ', given_name and family_name cannot be blank'
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
