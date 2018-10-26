class Reminder < ApplicationRecord
  belongs_to :person, optional: true
  belongs_to :event, optional: true
end
