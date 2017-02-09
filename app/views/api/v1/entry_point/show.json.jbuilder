json.docs do
  json.href 'https://github.com/wufm/osdi-docs'
  json.title 'Documentation'
end

json.set! '_links' do
  json.set! 'osdi:people' do
    json.href api_v1_people_url
  end
end

json.self do
  json.href api_v1_url
  json.title 'root API entry point'
end
