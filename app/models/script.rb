class Script < ApplicationRecord

  #confusing to have creator and person... what's the person?
  belongs_to :modified_by, :class_name => "Person"
  belongs_to :creator, :class_name => "Person"
  belongs_to :canvassing_effort

  has_many :script_questions
  has_many :questions, :through => "script_questions"
end
