json.extract! @member, :id, :created_at, :updated_at
json.url member_url(@member, format: :json)