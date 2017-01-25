class GroupSerializer < ActiveModel::Serializer
<<<<<<< HEAD
  attributes :id, :origin_system, :name, :description, :summary, :browser_url, :featured_image_url, :creator_id
  has_many :advocacy_campaigns_groups
=======
  attributes :origin_system, :name,  :description,  :summary,  :browser_url,  :featured_image_url
  belongs_to :creator, :class_name => "Person"
  belongs_to :modified_by, :class_name => "Person"
>>>>>>> d57049f836082947a833bd905c776954ff7caaa4
end


#t.integer  "modified_by_id"
#t.datetime "created_at",         null: false
#t.datetime "updated_at",
