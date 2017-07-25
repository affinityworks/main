class MembersController < ApplicationController
  before_action :authenticate_person!
  before_action :authorize_group_access
  before_action :set_group
  before_action :set_members, only: :index
  before_action :set_member, only: [:show, :edit, :update, :destroy]

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
        person = Person.find(params[:id])
        render json: JsonApi::PeopleRepresenter.new(person).to_json
      end
    end
  end

  def attendances
    person = Person.find(params[:id])
    attendances = person.attendances.includes(:event).order('events.start_date')
    respond_to do |format|
      format.html
      format.json do
        render json: JsonApi::AttendanceWithEventsRepresenter.for_collection.new(attendances).to_json
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
    params_person = params["person"]["person"]
    email_params = params["person"]["email_address"]
    phone_params = params["person"]["phone_number"]
    attr = {}
    params_person.each do |k, v| 
      if v.present? 
        attr[k] = v
      end
    end
    @person = Person.create!(attr)
    if email_params["email_address"].present?
      unless EmailAddress.exists?(address: email_params["email_address"])
        EmailAddress.create!(person_id: @person.id, address: email_params["email_address"], primary: :true)
      end
    end
    if phone_params["phone_number"].present?
      PhoneNumber.create!(person_id: @person.id, number: phone_params["phone_number"], primary: :true)
    end

    @member = Membership.new(person_id: @person.id, group_id: params["group_id"])
    
    respond_to do |format|
      if @member.save
        format.html { redirect_to group_dashboard_path, notice: 'Member was added to your group.' }
        format.json { render :show, status: :created, location: @member }
      else
        format.html { render :new }
        format.json { render json: @member.errors, status: :unprocessable_entity }
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
  # def member_params
  #   params.permit(:person => [:person => [:family_name, :given_name, :gender, :gender_identity, :party_identification, :ethnicities, :languages_spoken, :birthdate, :employer]] )
  #   params.permit(:person => { :email_address } )
  #   params.permit{ :phone_number }
  #   params.permit{ :group_id }
  # end

  def set_member
    @member = @group.members.where(:id => params[:id])
  end

  def set_group
    @group = Group.find(params[:group_id])
  end

  def set_members
    @members = @group.all_members.includes(
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
