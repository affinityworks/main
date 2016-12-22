class SharePage < ApplicationRecord
  belongs_to :creator
  belongs_to :modified_by
end
