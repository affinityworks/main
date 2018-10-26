class Note < ApplicationRecord
  belongs_to :notable, polymorphic: true, optional: true
  belongs_to :author, class_name: 'Person', optional: true
end
