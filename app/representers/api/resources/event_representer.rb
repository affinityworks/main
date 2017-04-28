class Api::Resources::EventRepresenter < Api::Resources::Representer
  include Api::Resources::Identified

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
  property :osdi_type, as: :type
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
  property :visibility

  property :location, decorator: Api::Resources::AddressRepresenter, class: EventAddress
end
