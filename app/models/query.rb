class Query < ApplicationRecord
  belongs_to :creator, :class_name => "Person"
  belongs_to :modified_by, :class_name => "Person"

  #this is for setting up a fixed query of many resources on the OSDI server
  # need to impliment this.
end
