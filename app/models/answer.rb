class Answer < ApplicationRecord
  belongs_to :responses
  belongs_to :person
  belongs_to :question
  belongs_to :canvass
end
