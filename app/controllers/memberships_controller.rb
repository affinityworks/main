class MembershipsController < ApplicationController
  before_action :authenticate_person!
  before_action :authorize_group_access
  before_action :find_memberships, only: [:index]
  #before_action :authorize_and_load_membership, only: [:show]

  def index
    respond_to do |format|
      format.html
      format.json do
        render json: {
          memberships: JsonApi::MembershipRepresenter.for_collection.new(@memberships),
          tags: JsonApi::TagsRepresenter.for_collection.new(Tag.type_membership),
          total_pages: @memberships.total_pages,
          page: @memberships.current_page
        }.to_json
      end
    end
  end

  def show
    @membership = Membership.find_by(
      person_id: params[:id], group_id: params[:group_id]
    )
    authorize! :manage, @membership #Group.find(params[:group_id])

    respond_to do |format|
      format.html
      format.json do
        render json: JsonApi::MembershipRepresenter.new(@membership)
      end
    end
  end

  def update
    @membership = Membership.find(:id).role
    respond_to do |format|
    if @membership.role == "member"
      @membership.update(role: 'organizer')
      format.html { redirect_to group_dashboard_path, notice: 'Member is now an Organizer.' }
      format.json { render :show, status: :created, location: @membership }
    else
      @membership.update(role: 'member')
      format.html { redirect_back(fallback_location: root_path) }
      format.json { render json: @membership.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def find_memberships

    if current_group
      #are we looking at the person in the context of a specific group, then what groups can we see
      member_ids = Membership.where(:group_id =>current_group.affiliates.pluck(:id).push(current_group.id) ).pluck(:id)
    else  #or did we not get any group
      organized_groups_ids = current_user.organized_groups.pluck(:id)
      group_ids = Membership.where(:group_id =>organized_groups_ids.concat(organized_groups_ids).uniq).pluck(:id)
    end


    @memberships = Membership.select("memberships.*, people.given_name, addresses.locality").distinct.where(:id => member_ids).
      joins(:person).
      joins(ArelHelpers.join_association(Person, [:email_addresses, :personal_addresses, :phone_numbers], Arel::Nodes::OuterJoin) ).
      page(params[:page])

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
      else
        sort_param
      end
      @memberships = @memberships.order("#{sort} #{direction_param}")
    end
  end

  def sort_param
     return unless params[:sort] || nil
    @sort_param ||= ['name', 'role', 'group_name', 'addresses.locality'].delete(params[:sort])
  end

  def authorize_and_load_membership
    return true
  end
end
