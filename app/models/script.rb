class Script < ApplicationRecord
  belongs_to :person
  belongs_to :creator
  belongs_to :canvassing_effort
end
