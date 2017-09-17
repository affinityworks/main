class MembersController < ApplicationController
  before_action :authenticate_person!
  before_action :authorize_group_access
  before_action :set_group
  before_action :set_members, only: :index
  before_action :set_member, only: [:show, :edit, :update, :destroy, :attendances]

  protect_from_forgery except: [:update, :create] #TODO: Add the csrf token in react.

  def index
    respond_to do |format|
      format.html
      format.json do
        render json: {
          members: JsonApi::PeopleRepresenter.for_collection.new(Person.add_event_attended(@members, current_group)),
          total_pages: @members.total_pages,
          page: @members.current_page
        }.to_json
      end
    end
  end

  def show
    respond_to do |format|
      format.html
      format.json do
        render json: JsonApi::PeopleRepresenter.new(@member).to_json
      end
    end
  end

  def attendances
    @attendances = @member.attendances.includes(:event).order('events.start_date')
    respond_to do |format|
      format.html
      format.json do
        render json: JsonApi::AttendanceWithEventsRepresenter.for_collection.new(@attendances).to_json
      end
    end
  end

  # GET /groups/:id/members/new
  def new
    @member = @group.members.new
    authorize! :manage, @group
  end

  # GET /groups/:id/members/1/edit
  def edit
    @groups = Group.all
    set_group
    authorize! :manage, @group
  end 


  # POST /groups/:id/members/
  # POST /groups/:id/members/.json
  def create
    @person = Person.new(person_params)

    respond_to do |format|
      if @person.save
        @group.memberships.create(:person => @person, :role => 'member')
        format.html { redirect_to group_member_path(@group, @person), notice: 'Member was successfully created.' }
        format.json { render json: @person, status: :created, location: group_members_path(@group) }
      else
        format.html { render :new }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end

  end


  # PATCH/PUT /groups/1
  # PATCH/PUT /groups/1.json
  def update
    respond_to do |format|
      if @member.update(member_params)
        format.html { redirect_to group_dashboard_path, notice: 'Member was successfully updated.' }
        format.json { render :show, status: :ok, location: @member }
      else
        format.html { render :edit }
        format.json { render json: @member.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /groups/1
  # DELETE /groups/1.json
  def destroy
    @member.destroy
    respond_to do |format|
      format.html { redirect_to members_url, notice: 'Person record was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # only returns nil / empty symbol
  def person_params
    params.require(:person).permit([
          :family_name,
          :given_name, 
          :gender, 
          :gender_identity, 
          :party_identification, 
          :birthdate, 
          :employer,
          :primary_email_address,
          :primary_phone_number,   
          { :ethnicities => []}, 
          {:languages_spoken => []},
          {:custom_fields => {}}
     ]
      )
  end

  def email_params
    params.require(:person).permit(email_address: :email_address)
  end

  def phone_params
    params.require(:person).permit(phone_number: :phone_number)
  end

  def set_member
    #@membership = Membership.where(:group_id =>@group.affiliates.pluck(:id).push(@group.id) )
    if @group 
      #are we looking at the person in the context of a specific group, then what groups can we see
      group_ids = @group.affiliates.pluck(:id).push(@group.id)
    else  #or did we not get any group
      organized_groups_ids = current_user.organized_groups.pluck(:id)
      group_ids = Affiliation.where(:group_id =>organized_groups_ids).pluck(:affiliated_id).concat(organized_groups_ids).uniq
    end
    @memberships = Membership.where(:group_id => group_ids, :person_id => params[:id])
    @member = @memberships.first.person if @memberships.any?
  end

  def set_group
    @group = Group.find(params[:group_id]) if params[:group_id]
  end

  def set_members
    
    member_ids = Membership.where(:group_id =>@group.affiliates.pluck(:id).push(@group.id) ).pluck(:person_id)
    
    @members = Person.where(:id => member_ids).includes(
        [:email_addresses, :personal_addresses, :phone_numbers]
      ).page(params[:page])

    if params[:filter]
      #in the future we might want ot search all fields like address, town, city, state... etc....
      @members = @members.where('given_name ilike ? or family_name ilike ?', "%#{params[:filter]}%","%#{params[:filter]}%")
      #members = Member.arel_table
      #wildcard_search = "%#{params[:filter]}%"

      #@members = @members.where('given_name ilike :search or family_name ilike :search', :search wildcard_search)
    elsif params[:email]
      @members = @members.by_email(params[:email])
    end

    if params[:sort]
      @members = @members.order(params[:sort] => params[:direction])
    end
  end

end

