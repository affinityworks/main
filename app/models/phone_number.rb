class PhoneNumber < ApplicationRecord
  include ArelHelpers::ArelTable
  belongs_to :person

  validates :number, :presence => true, :numericality => true
  validates_uniqueness_of :number, scope: :person_id

  scope :primary, -> { where(primary: true) }
end
