class Query < ApplicationRecord
  belongs_to :creator, :class_name => "Person", optional: true
  belongs_to :modified_by, :class_name => "Person", optional: true

  #this is for setting up a fixed query of many resources on the OSDI server
  # need to impliment this.
end
