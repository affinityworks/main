class Submission < ApplicationRecord
  belongs_to :form
  belongs_to :person
  belongs_to :referrer_data
end
