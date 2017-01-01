#Recipient of a donation

class Recipient < ApplicationRecord
  belongs_to :donation
end
