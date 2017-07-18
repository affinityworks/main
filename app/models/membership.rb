class Membership < ApplicationRecord
  acts_as_taggable
  has_paper_trail
  
  #inversions allow back and forth permissions within forms
  belongs_to :group, inverse_of: :group
  belongs_to :person, inverse_of: :person
  has_many :notes, as: :notable

  validates :person_id, uniqueness: { scope: :group_id }
  validates :group_id, uniqueness: { scope: :person_id }
  #for form helpers
  accepts_nested_attributes_for :group

  enum role: [:member, :organizer]

  #this doesn't do what i'd hoped - rabble
    # still need to work to be able to do group.organizers
  scope :member, -> { where(:role => :member) }
  scope :organizer, -> { where(:role => :organizer) }

  scope :by_name, -> (name) do
    where("CONCAT_WS(' ', people.given_name, people.family_name) ILIKE ?", "%#{name}%")
  end

  scope :by_email, -> (email) do
    where("email_addresses.address ILIKE ?", "%#{email}%")
  end

  scope :by_location, -> (location) do
    where("addresses.locality ILIKE ?", "%#{location}%")
  end
end
