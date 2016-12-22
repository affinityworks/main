class AdvocacyCampaign < ApplicationRecord
  belongs_to :creator, class_name: "Person"
  belongs_to :modified_by, class_name: "Person"

  has_many :outreaches
  
  def types
    ['email', 'in-person', 'phone', 'postal mail']
  end
end
