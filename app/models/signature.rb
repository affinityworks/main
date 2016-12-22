class Signature < ApplicationRecord
  belongs_to :referrer_data
  belongs_to :petition
  belongs_to :person
end
