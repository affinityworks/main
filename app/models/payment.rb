class Payment < ApplicationRecord
  belongs_to :donation, optional: true
end
