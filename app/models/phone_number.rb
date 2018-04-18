# == Schema Information
#
# Table name: phone_numbers
#
#  id          :integer          not null, primary key
#  primary     :boolean
#  number      :string
#  extension   :string
#  description :string
#  number_type :string
#  operator    :string
#  country     :string
#  sms_capable :boolean
#  do_not_call :boolean
#  person_id   :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class PhoneNumber < ApplicationRecord
  include ArelHelpers::ArelTable
  belongs_to :person
  PHONE_FORMAT = /\A(\+\d{1,2}[\s-]?)?\(?\d{3}\)?[\s.-]?\d{3}[\s.-]?\d{4}\z/

  validates :number, :presence => true,
            format: { with:  PHONE_FORMAT,
                      message: "'%{value}' is not a valid phone number" }
  validates_uniqueness_of :number, scope: :person_id

  scope :primary, -> { where(primary: true) }

  # TODO: (aguestuser|28-Feb-2018)
  # add before_create hook to impose standard formatting on phone numbers
end
