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
