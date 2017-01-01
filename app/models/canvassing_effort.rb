class CanvassingEffort < ApplicationRecord
  has_one :script
  belongs_to :creator, :class_name => "Person"
  belongs_to :modified_by, :class_name => "Person"
  has_many :canvasses
  has_and_belongs_to_many :questions
end
