json.extract! @group, :id, :origin_system, :name, :creator_id, :created_at, :updated_at
json.extract! @affiliation, :id, :affiliated_id, :created_at, :updated_at
json.url group_url(group, format: :json)