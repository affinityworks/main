#Recipient of a donation

class Recipient < ApplicationRecord
  belongs_to :donation, optional: true
end
