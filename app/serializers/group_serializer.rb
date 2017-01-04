class GroupSerializer < ActiveModel::Serializer
  attributes :id, :origin_system, :name, :description, :summary, :browser_url, :featured_image_url, :creator_id
end
