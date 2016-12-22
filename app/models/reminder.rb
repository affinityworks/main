class Reminder < ApplicationRecord
  belongs_to :people
  belongs_to :event
end
