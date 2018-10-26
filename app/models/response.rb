class Response < ApplicationRecord
  belongs_to :question, optional: true
end
