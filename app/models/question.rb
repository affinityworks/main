class Question < ApplicationRecord
  belongs_to :creator, :class_name => "Person"
  belongs_to :modified_by, :class_name => "Person"
  has_many :answers
  
end
