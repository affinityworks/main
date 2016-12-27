class Form < ApplicationRecord
  belongs_to :person
  belongs_to :creator
  belongs_to :submissions
  has_many :answers, :through => "Questions"
end
