class Outreach < ApplicationRecord
  belongs_to :referrer_data
  belongs_to :advocacy_campaign
  belongs_to :person
  has_and_belongs_to_many :targets
end
