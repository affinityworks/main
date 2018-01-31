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
  PHONE_FORMAT = /\A(\((\d){3}\)\s|(\+1-)?(\d){3}-)(\d){3}-(\d){4}|(\d){10}\z/
  validates :number, :presence => true,
            format: { with:  PHONE_FORMAT,
            message: 'Only numbers format are allowed' }
  validates_uniqueness_of :number, scope: :person_id

  scope :primary, -> { where(primary: true) }
end
