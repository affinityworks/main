class Api::Collections::PeopleRepresenter < Api::Collections::Representer
  link :self do
    api_v1_people_url
  end

  collection :people, as: 'osdi:people', class: Person, extend: Api::Resources::PersonRepresenter, embedded: true

  link :previous do
    api_v1_people_path(page: represented.prev_page) unless represented.first_page?
  end

  link :next do
    api_v1_people_path(page: represented.next_page) unless represented.last_page?
  end
end
