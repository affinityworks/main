class Zipcode < ApplicationRecord
  validates :zipcode, uniqueness: true
end
