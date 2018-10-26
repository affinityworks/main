class TwitterShare < ApplicationRecord
  belongs_to :share_page, optional: true
end
