class CanvassingEffort < ApplicationRecord
  has_one :script
  belongs_to :creator, :class_name => "Person", optional: true
  belongs_to :modified_by, :class_name => "Person", optional: true
  has_many :canvasses
  has_and_belongs_to_many :questions
end
