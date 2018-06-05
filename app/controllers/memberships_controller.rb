class MembershipsController < ApplicationController
  before_action :authenticate_person!
  before_action :authorize_group_access
  before_action :find_memberships, only: [:index]
  before_action :find_group_tags, only: [:index]
  # TODO: THIS IS DANGEROUS!!!
  # for fix, wee comment in `client/app/bundles/Events/utils/Client.jsx`
  protect_from_forgery except: [:destroy]

  def index
    respond_to do |format|
      format.html
      format.json do
        render json: {
          memberships: JsonApi::MembershipRepresenter.for_collection.new(@memberships),
          tags: JsonApi::TagsRepresenter.for_collection.new(@tags),
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

    authorize! :read, @membership #Group.find(params[:group_id])

    respond_to do |format|
      format.html
      format.json do
        render json: JsonApi::MembershipRepresenter.new(@membership)
      end
    end
  end

  # POST /memberships
  # POST /groups/:group_id/memberships

  def create
    if @membership = Membership.create(membership_params)
      redirect_to group_dashboard_path(@membership.group),
                  notice: "You are now a member of #{@membership.group.name}"
    else
      redirect_to profile_home_path,
                  error: "Failed to create new membership"
    end
  end

  def update
    # NOTE (aguestuser): I just moved this here. i did not write it!
    # i strongly suspect that this code would crash if ever executed
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

  # DELETE /groups/:group_id/memberships/:id
  # DELETE /groups/:group_id/memberships/:id.json
  def destroy
    @membership = Membership.find(params.require(:id).to_i)
    member = @membership.person
    group = @membership.group

    @membership.destroy
    Memberships::AfterDestroy.call(member: member, group: group)

    respond_to do |format|
      format.html { redirect_to members_url, notice: 'Membership destroyed.' }
      format.json do
        render json: { membership: { id: @membership.id } }
      end
    end
  end


  private

  def membership_params
    params.require(:membership).permit(:group_id, :person_id, :role)
  end

  def find_memberships
    @memberships = 
      Membership
        .includes(:group, :tags, :notes, person: [ :email_addresses, 
                                                   :personal_addresses, 
                                                   :phone_numbers, 
                                                   :groups ])
        .where(group_id: current_group.affiliates.pluck(:id).push(current_group.id))
        .order("#{sort_param} #{direction_param}")
        .page(params[:page])

    @memberships = @memberships.tagged_with(params[:tag]) if params[:tag]

    if search_term = params[:filter]
      @memberships = 
        @memberships.by_name(search_term)
          .or(@memberships.by_email(search_term))
          .or(@memberships.by_location(search_term))
    end
  end

  def find_group_tags
    @tags =
      Tag.type_membership_with_ids(current_group.memberships.pluck(:id))
  end

  def sort_param
    #return unless params[:sort] || nil
    @sort_param ||= ['name', 'role', 'group_name', 'addresses.locality']
      .delete(params.fetch(:sort, 'name'))
      .gsub('name', 'people.given_name')  
  end

  def authorize_and_load_membership
    return true
  end
end
