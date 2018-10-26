class Signature < ApplicationRecord
  belongs_to :referrer_data, optional: true
  belongs_to :petition, optional: true
  belongs_to :person, optional: true
end
