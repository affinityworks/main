class Question < ApplicationRecord
  belongs_to :creator, :class_name => "Person", optional: true
  belongs_to :modified_by, :class_name => "Person", optional: true
  has_many :answers
  
end
