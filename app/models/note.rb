class Note < ApplicationRecord
  belongs_to :notable, polymorphic: true
  belongs_to :author, class_name: 'Person'
end
