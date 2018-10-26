class FundraisingPage < ApplicationRecord
  belongs_to :creator, :class_name => "Person", optional: true
  has_many :donations

end
