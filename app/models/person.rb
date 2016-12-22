class Person < ApplicationRecord

  has_one :email_address
  has_one :employer_address, :class_name => 'Address'

  has_many :personal_addresses, :class_name => 'Address'
  has_many :phone_numbers
  has_many :profiles


  validates :given_name, presence: true

end
