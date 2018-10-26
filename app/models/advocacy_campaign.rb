class AdvocacyCampaign < ApplicationRecord
  belongs_to :creator, class_name: "Person", optional: true
  belongs_to :modified_by, class_name: "Person", optional: true

  validates_presence_of :creator

  has_many :outreaches

  def types
    ['email', 'in-person', 'phone', 'postal mail']
  end

  def before_create
    self.modified_by = self.creator
  end
end
