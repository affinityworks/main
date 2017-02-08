require 'roar/json/hal'

class Api::PeopleRepresenter < Representable::Decorator
  include Roar::JSON::HAL
  include Rails.application.routes.url_helpers

  link :self do
    api_v1_people_url
    # '/api/v1/people'
  end

  collection :to_a, as: 'osdi:people', class: Person, extend: Api::PersonRepresenter, embedded: true

  link :previous do
    "/api/v1/people?page=#{represented.prev_page}"
  end

  property :current_page, as: :page
  property :size, as: :total_pages
  property :total_count, as: :total_records

  def default_url_options
    Rails.application.default_url_options or {}
  end
end
