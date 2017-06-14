class Origin < ActiveRecord::Base
  has_many :attendance_origins
  has_many :attendances, through: :attendance_origins
  has_many :tag_origins
  has_many :tags, through: :tag_origins

  scope :action_network, -> { find_by(name: 'Action Network') }
  scope :facebook, -> { find_by(name: 'Facebook') }
  scope :affinity, -> { find_by(name: 'Affinity') }
end
