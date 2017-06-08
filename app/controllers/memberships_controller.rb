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
    @memberships = Group.find(params[:group_id]).memberships.joins(:person).includes( #TODO: Also get affiliates memberships
      person: [:email_addresses, :personal_addresses, :phone_numbers]
    ).page(params[:page])

    if params[:filter]
      @memberships = @memberships
        .where('people.given_name ilike ? or people.family_name ilike ?',
          "%#{params[:filter]}%","%#{params[:filter]}%"
        )
    end

    if sort_param && direction_param
      sort = sort_param == 'name' ? 'people.given_name' : sort_param

      @memberships = @memberships.order("#{sort} #{direction_param}")
    end
  end

  def sort_param
    @sort_param ||= ['name', 'role'].include?(params[:sort]) && params[:sort] || nil
  end
end
