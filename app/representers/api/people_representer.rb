require 'roar/json/hal'

class Api::PeopleRepresenter < Representable::Decorator
  include Roar::JSON::HAL
  include Rails.application.routes.url_helpers

  link :self do
    api_v1_people_url
  end

  collection :to_a, as: 'osdi:people', class: Person, extend: Api::PersonRepresenter, embedded: true

  link :previous do
    api_v1_people_path(page: represented.prev_page)
  end

  link :next do
    api_v1_people_path(page: represented.next_page)
  end

  property :current_page, as: :page
  property :size, as: :total_pages
  property :total_count, as: :total_records

  def initialize(people, request)
    @request = request
    super people
  end

  def default_url_options
    { host: @request.host }
  end
end
