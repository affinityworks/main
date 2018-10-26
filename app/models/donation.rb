class Donation < ApplicationRecord
  belongs_to :referrer_data, optional: true
  belongs_to :person, optional: true
  belongs_to :fundraising_page, optional: true
  belongs_to :attendance, optional: true
  has_one :payment
  has_one :recipient
end
