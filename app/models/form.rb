class Form < ApplicationRecord
  belongs_to :person
  belongs_to :creator, :class_name => "Person"
  has_many :submissions
  has_many :answers, :through => "Questions"
end
