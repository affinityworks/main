class ReferrerData < ApplicationRecord
  has_one :donation
  has_one :outreach
  has_one :signature
end
