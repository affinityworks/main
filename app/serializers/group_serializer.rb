class GroupSerializer < ActiveModel::Serializer
  attributes :origin_system, :name,  :description,  :summary,  :browser_url,  :featured_image_url
  belongs_to :creator, :class_name => "Person"
  belongs_to :modified_by, :class_name => "Person"
end


#t.integer  "modified_by_id"
#t.datetime "created_at",         null: false
#t.datetime "updated_at",
