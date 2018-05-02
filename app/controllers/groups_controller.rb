class GroupsController < ApplicationController
  before_action :authorize_group_access, except: [:new, :join]
  before_action :set_group, only: [:show, :edit, :update, :destroy, :join]
  before_action :authenticate_person!, except: [:join]

  protect_from_forgery except: [:update] #TODO: Add the csrf token in react.

  # GET /groups
  # GET /groups.json
  def index
    @groups = params[:tag] ? Group.tagged_with(params[:tag]) : Group.all
    @groups = @groups.includes(:creator).page(params[:page])

    if sort_param && direction_param
      sort = sort_param == 'owner' ? 'people.given_name' : sort_param

      @groups = @groups.order("#{sort} #{direction_param}")
    end

    respond_to do |format|
      format.html
      format.json do
        render json: {
          groups: JsonApi::GroupsRepresenter.for_collection.new(@groups),
          total_pages: @groups.total_pages,
          page: @groups.current_page
        }.to_json
      end
    end
  end

  # GET /groups/1
  # GET /groups/1.json
  def show
    respond_to do |format|
      format.html
      format.json do
        render json: JsonApi::GroupRepresenter.new(@group).to_json
      end
    end
  end

  # GET /groups/new
  def new
    @group = Group.new
  end

  # GET /groups/1/edit
  def edit
    @groups = Group.all
    set_group
    authorize! :manage, @group
  end

  # POST /groups
  # POST /groups.json
  def create
    @group = Group.new(group_params)
    respond_to do |format|
      if @group.save
        format.html { redirect_to group_dashboard_path, notice: 'Group was successfully created.' }
        format.json { render :show, status: :created, location: @group }
      else
        format.html { render :new }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /groups/1
  # PATCH/PUT /groups/1.json
  def update
    #affiliated_id and group_id are switched due to table being backwards. refactor upon completion
    affiliated_id = params.dig(:affiliation, :affiliated_id)
    @affiliates = Affiliation.find_or_create_by!({affiliated_id: params[:id], group_id: affiliated_id }) if affiliated_id
    respond_to do |format|
      if @group.update(group_params)
        format.html { redirect_to group_dashboard_path(@group), notice: 'Group was successfully updated.' }
        format.json { render :show, status: :ok, location: @group }
      else
        format.html { render :edit }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /groups/1
  # DELETE /groups/1.json
  def destroy
    @group.destroy
    respond_to do |format|
      format.html { redirect_to groups_url, notice: 'Group was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # GET /groups/1/join
  def join
    @membership = Membership.new
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_group
    @group = Group.find(params[:id] || params[:group_id])
  end

  def authorized_controllers_and_actions?
    action_name == 'show'
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def group_params
    params.require(:group).permit(:origin_system, :name, :description, :summary, :creator_id, :person_id, :memberships, :current_members, :role, :whiteboard)
  end

  def sort_param
    @sort_param ||= ['name', 'owner'].include?(params[:sort]) && params[:sort] || nil
  end
end
