json.extract! person, :id, :created_at, :updated_at
json.url member_url(person, format: :json)