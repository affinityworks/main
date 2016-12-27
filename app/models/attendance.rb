class Attendance < ApplicationRecord
  has_many :tickets
  belongs_to :person
  belongs_to :event
end
