json.self do
  json.href api_v1_people_url
end

json.set! '_embedded' do
  json.set! 'osdi:people' do
    json.array! @people do |person|
      json.identifiers [osdi_identifier(person)]
      json.created_date person.created_at
      json.modified_date person.updated_at

      json.id person.id

      json.email_address do
        # OSDI specs many emails per person. Our current schema has one.
        json.array! Array.wrap(person.email_address) do |email_address|
          json.primary email_address.primary?
          json.address email_address.address
        end
      end
    end
  end
end

json.set! '_links' do
  json.self do
    json.href api_v1_people_url
  end
end

json.page 1
json.per_page @people.size
json.total_records @people.size
