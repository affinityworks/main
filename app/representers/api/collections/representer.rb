require 'roar/client'
require 'roar/json/hal'

class Api::Collections::Representer < Roar::Decorator
  include Roar::Client
  include Roar::JSON::HAL
  include Rails.application.routes.url_helpers

  property :page
  property :total_pages
  property :total_records

  # Rails +request+ is required to calculate path with proper host and params
  def initialize(resources, request = nil)
    @request = request
    super resources
  end

  def default_url_options
    { host: @request.host }
  end
end
