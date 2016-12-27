class FundraisingPage < ApplicationRecord
  belongs_to :creator, :class_name => "Person"
  has_many :donations

end
