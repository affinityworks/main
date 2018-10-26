class TicketLevel < ApplicationRecord
  belongs_to :event, optional: true
end
