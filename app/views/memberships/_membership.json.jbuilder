json.extract! @membership, :id, :role, :created_at, :updated_at
json.extract! @person, :id, :name, :created_at, :updated_at
json.extract! @group, :id, :name
json.url group_url(group, format: :json)