class Event < ApplicationRecord
  belongs_to :ticket_levels
  belongs_to :address
end
