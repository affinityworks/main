class Affiliation < ApplicationRecord
  belongs_to :group, foreign_key: 'group_id', class_name: 'Group'
  belongs_to :affiliated, foreign_key: 'affiliated_id', class_name: 'Group'
end
