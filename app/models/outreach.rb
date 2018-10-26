class Outreach < ApplicationRecord
  belongs_to :referrer_data, optional: true
  belongs_to :advocacy_campaign, optional: true
  belongs_to :person, optional: true
  has_and_belongs_to_many :targets
end
