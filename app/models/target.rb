class Target < ApplicationRecord
  has_and_belongs_to_many :outreaches
  has_and_belongs_to_many :petitions
end
