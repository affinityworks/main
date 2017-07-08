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

  def show
    @membership = Membership.find_by!(
      person_id: params[:id], group_id: params[:group_id]
    )

    respond_to do |format|
      format.html
      format.json do
        render json: JsonApi::MembershipRepresenter.new(@membership)
      end
    end
  end


  # def update_role
  #   @membership = Membership.find_by!(group_id: params[:group_id],  person_id:[:id])
   
  #   if @membership.role == "member"
  #     @membership.update(role: 1)
  #   else 
  #     @membership.update(role: 0)
  #   end   
  # end

  private

  def find_memberships
    @memberships = Group.find(params[:group_id]).all_memberships.joins(:person, :group).eager_load(
      person: [:email_addresses, :personal_addresses, :phone_numbers]
    ).page(params[:page])

    @memberships = @memberships.tagged_with(params[:tag]) if params[:tag]

    if search_term = params[:filter]
      @memberships = @memberships.by_name(search_term).or(
        @memberships.by_email(search_term)
      ).or(
        @memberships.by_location(search_term)
      )
    end

    if sort_param && direction_param
      sort = if sort_param == 'name'
        'people.given_name'
      elsif sort_param == 'group_name'
        'groups.name'
      else
        sort_param
      end

      @memberships = @memberships.order("#{sort} #{direction_param}")
    end
  end

  def sort_param
    @sort_param ||= ['name', 'role', 'group_name'].include?(params[:sort]) && params[:sort] || nil
  end
end
