class Ticket < ApplicationRecord
  belongs_to :attendance, optional: true
end
