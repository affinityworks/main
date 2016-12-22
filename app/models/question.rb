class Question < ApplicationRecord
  belongs_to :creator
  belongs_to :mondified_by
end
