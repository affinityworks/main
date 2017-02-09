json.self do
  json.href api_v1_people_url
end

json.set! '_embedded' do
  json.set! 'osdi:people' do
    json.array! @people, partial: 'api/v1/people/person', as: :person
  end
end

json.set! '_links' do
  json.self do
    json.href api_v1_people_url
  end

  unless @people.first_page?
    json.previous do
      json.href api_v1_people_path(page: @people.prev_page)
    end
  end

  unless @people.last_page?
    json.next do
      json.href api_v1_people_path(page: @people.next_page)
    end
  end
end

json.page @people.current_page
json.total_pages @people.size
json.total_records @people.total_count
