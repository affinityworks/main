class Answer < ApplicationRecord
  belongs_to :responses, optional: true
  belongs_to :person, optional: true
  belongs_to :question, optional: true
  belongs_to :canvass, optional: true
end
