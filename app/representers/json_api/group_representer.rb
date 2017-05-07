class JsonApi::GroupRepresenter < Roar::Decorator
  include Roar::JSON

  property :id
  property :name
  property :origin_system
  property :description
  property :summary
  property :browser_url
  property :featured_image_url

  property :creator, decorator: Api::Resources::PersonRepresenter, class: Person
end
