class Donation < ApplicationRecord
  belongs_to :referrer_data
  belongs_to :person
  belongs_to :fundraising_page
  belongs_to :attendance
  has_one :payment
  has_one :recipient
end
