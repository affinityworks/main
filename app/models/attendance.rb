class Attendance < ApplicationRecord
  include Api::Identifiers

  # TODO: these are just for import and need to move
  attr_accessor :event_uuid
  attr_accessor :person_uuid

  has_many :tickets
  belongs_to :person
  belongs_to :event
end
