class Form < ApplicationRecord
  belongs_to :person
  belongs_to :creator
  has_many :submissions
  has_many :answers, :through => "Questions"
end
