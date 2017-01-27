class PhoneNumber < ApplicationRecord

  belongs_to :person

  validates_presence_of :number
end
