#social media profiles

class Profile < ApplicationRecord
  belongs_to :person, optional: true
end
