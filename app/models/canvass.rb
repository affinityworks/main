class Canvass < ApplicationRecord
  belongs_to :canvassing_effort, optional: true
  has_many :answers
  belongs_to :canvasser, :class_name => "Person", optional: true
  belongs_to :target, :class_name => "Person", optional: true
end
