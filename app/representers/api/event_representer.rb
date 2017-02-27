require 'roar/json/hal'

class Api::EventRepresenter < Roar::Decorator
  include Roar::JSON::HAL

  property :created_at, as: :created_date
  property :updated_at, as: :modified_date

  property :all_day
  property :all_day_date
  property :browser_url
  property :capacity
  property :description
  property :end_date
  property :featured_image_url
  property :guests_can_invite_others
  property :instructions
  property :name
  property :origin_system
  property :share_url
  property :start_date
  property :status
  property :summary
  property :title
  property :total_accepted
  property :total_amount
  property :total_shares
  property :total_tickets
  property :transparency
  property :type
  property :visibility

  link :self do
    "/api/v1/events/#{represented.id}"
  end
end
