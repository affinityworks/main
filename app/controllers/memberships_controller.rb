class MembershipsController < ApplicationController
  before_action :authenticate_person!
  before_action :authorize_group_access
  before_action :find_memberships, only: :index

  def index
    respond_to do |format|
      format.html
      format.json do
        render json: {
          memberships: JsonApi::MembershipRepresenter.for_collection.new(@memberships),
          total_pages: @memberships.total_pages,
          page: @memberships.current_page
        }.to_json
      end
    end
  end

  private

  def find_memberships
    @memberships = current_group.memberships.joins(:person).includes(
      person: [:email_addresses, :personal_addresses, :phone_numbers]
    ).page(params[:page])

    if params[:filter]
      @memberships = @memberships
        .where('people.given_name ilike ? or people.family_name ilike ?',
          "%#{params[:filter]}%","%#{params[:filter]}%"
        )
    end

    if sortParam && directionParam
      sort = sortParam == 'name' ? 'people.given_name' : sortParam

      @memberships = @memberships.order("#{sort} #{directionParam}")
    end
  end

  def sortParam
    @sortParam ||= ['name', 'role'].include?(params[:sort]) && params[:sort] || nil
  end

  def directionParam
    @directionParam ||= ['asc', 'desc'].include?(params[:direction]) && params[:direction] || nil
  end
end
