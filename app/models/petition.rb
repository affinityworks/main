class Petition < ApplicationRecord
  has_and_belongs_to_many :targets
  has_and_belongs_to_many :signatures
  belongs_to :creator, :class_name => "Person", optional: true
  belongs_to :modified_by, :class_name => "Person", optional: true

end
