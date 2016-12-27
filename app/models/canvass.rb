class Canvass < ApplicationRecord
  belongs_to :canvassing_effort
  has_many :answers
  belongs_to :canvasser, :class_name => "Person"
  belongs_to :target, :class_name => "Person"
end
