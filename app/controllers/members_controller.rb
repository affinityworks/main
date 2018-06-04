class MembersController < ApplicationController
  SIGNUP_MODES = %w[email facebook google].freeze
  # authentication
  before_action :authenticate_person!, except: %i[new create]
  before_action :allow_logged_out_signups, only: %i[new create]
  before_action :authorize_group_access, except: %i[edit account update]

  # setters
  before_action :set_signup_mode, only: %i[new create edit update]
  before_action :set_oauth, only: %i[new create edit update]
  before_action :set_group, except: [:index]
  before_action :set_member, only: [:show, :edit, :update, :destroy, :attendances]
  before_action :set_person, only: [:account]
  before_action :authorize_member_access, only: %i[edit account update]
  before_action :build_member, only: %i[new create]
  before_action :build_member_resources, only: %i[new edit]
  before_action :set_target, only: %i[new create edit update]

  protect_from_forgery except: [:update, :create] #TODO: Add the csrf token in react.

  def index; end

  def show
    respond_to do |format|
      format.html
      format.json do
        render json: JsonApi::PeopleRepresenter.new(@member).to_json
      end
    end
  end

  # GET /groups/:id/members/new
  def new
    return render "signup_form_#{@signup_mode}", layout: "signup" if is_signup_form?
  end

  # POST /groups/:id/members/
  # POST /groups/:id/members/.json

  def create
    if Oauth.is_oauth_signup?(@signup_mode)
      @member = Person.create_from_oauth_signup(Oauth.decrypt_token(@oauth), person_params)
    elsif is_email_signup? && person = Person.find_by_email_param(person_params)
      return handle_create_dupe_email person.primary_email_address
    else
      @member = Person.create(person_params)
    end
    respond_to do |fmt|
      @member&.valid? ? handle_create_sucess(fmt) : handle_create_error(fmt)
    end
  end


  # GET /groups/:id/members/1/edit
  def edit
    return render "signup_form_#{@signup_mode}", layout: "signup" if is_signup_form?
  end

  # PATCH/PUT /groups/:id/members/1
  # PATCH/PUT /groups/:id/members/1.json
  def update
    respond_to do |format|
      if Oauth.is_oauth_signup?(@signup_mode)
        ok = @member.update_from_oauth_signup(Oauth.decrypt_token(@oauth), person_params)
      else
        ok = @member.update(person_params)
      end
      ok ? handle_update_success(format) : handle_update_error(format)
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

  def attendances
    @attendances = @member.attendances.includes(:event).order('events.start_date')
    respond_to do |format|
      format.html
      format.json do
        render json: JsonApi::AttendanceWithEventsRepresenter.for_collection.new(@attendances).to_json
      end
    end
  end

  def account
    group = determine_group_for_account

    return redirect_to edit_group_member_path(group_id: group.id, id: @person.id)
  end

  private

  def person_params
    params.require(:person).permit(
      :family_name,
      :given_name,
      :gender,
      :gender_identity,
      :party_identification,
      :birthdate,
      :employer,
      :password,
      :primary_email_address,
      :primary_phone_number,
      ethnicities: [],
      languages_spoken: [],
      custom_fields: {},
      memberships_attributes: [:id, :role],
      phone_numbers_attributes: [:id, :number, :primary, :_destroy],
      email_addresses_attributes: [:id, :address, :primary, :_destroy],
      personal_addresses_attributes: [:id, :primary, :postal_code],
      oauth: [:provider,
              :uid,
              credentials: [:token, :expires_at, :expires ],
              info:        [:email, :name, :image ] ]
    ).tap{ |person_attrs| handle_empty_contact_info(person_attrs) }
      .tap { |person_attrs| maybe_set_memberships(person_attrs) }
  end

  def authorize_member_access
    return if is_signup_form?
    
    case action_name 
    when "edit", "update"
      authorize! :manage, @member
    else
      authorize! :manage, @person
    end
  end

  def handle_empty_contact_info(person_attrs)
    if person_attrs.dig('phone_numbers_attributes', '0', 'number') == ''
      person_attrs.merge!('phone_numbers_attributes' => [])
    end
  end

  def maybe_set_memberships(person_attrs)
    # feels hacky. change this? (@aguestuser)
    if action_name == 'create' || is_signup_form?
      person_attrs.merge!(
        memberships_attributes: [{role: 'member', group: @group}]
      )
    end
  end

  # () -> ActionController::Parameters | String
  def oauth_params
    oauth = params.require(:person).require(:oauth)
    case action_name
    when 'new', 'edit' # => ActionController::Parameters
      oauth.permit(:provider,
                  :uid,
                  credentials: [:token, :expires_at, :expires ],
                  info:        [:email, :name, :image ])
    when 'create', 'update' # => String
      oauth
    end
  end

  def set_oauth
    @oauth = parse_oauth if Oauth.is_oauth_signup?(@signup_mode)
  end

  # String | ActionController::Parameters ->
  # OmniAuth::AuthHash | JSONString
  def parse_oauth
    case oauth_params
    when ActionController::Parameters
      JSON.generate(oauth_params.to_h)
    when String
      OmniAuth::AuthHash.new(JSON.parse(oauth_params).to_h)
    end.as_json
  end

  def allow_logged_out_signups
    authenticate_person! unless is_signup_form?
  end

  def set_group
    @group = current_group # this is dumb (@aguestuser)
  end

  def set_member
    if Oauth.is_oauth_signup?(@signup_mode)
      @member = Person.find(params.require(:id).to_i)
    else
      # NOTE: aguestuser thinks this is way to complex and should be re-written
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
  end

  def set_person
    @person = Person.find(params.require(:person_id).to_i)
  end

  def set_target
    return unless is_signup_form?
    case action_name
    when 'new', 'create'
      @target = group_members_path(@group, signup_mode: @signup_mode)
    when 'edit', 'update'
      @target = group_member_path(@group, @member, signup_mode: @signup_mode)
    end
  end

  def set_cancel
    @cancel = group_join_path(@group) if is_signup_form?
  end

  def build_member
    if action_name == 'new' && Oauth.is_oauth_signup?(@signup_mode)
      @member = Person.build_from_oauth_signup(OmniAuth::AuthHash.new(oauth_params.to_h))
    else
      @member = Person.new
    end
  end

  def build_member_resources
    %i[personal_addresses email_addresses phone_numbers].each do |x|
      @member.send(x).build(primary: true) if @member.send(x).empty?
    end
  end

  def set_signup_mode
    @signup_mode = SIGNUP_MODES.dup.delete params[:signup_mode]
  end

  def is_email_signup?
    @signup_mode == 'email'
  end

  def determine_group_for_account
    group = Group.find_by_id(params[:group_id])
    group&.member?(@person) ? group : @person.groups.first
  end

  ##########################
  # ACTION RESULT HANDLERS #
  ##########################

  def handle_create_sucess(fmt)
    fmt.html do
      Members::AfterCreate.call(member: @member, group: @group)
      if is_signup_form?
        flash[:notice] = "You joined #{@group.name}"
        session[:redirect_uri] = group_dashboard_path(@group)
        sign_in_and_redirect(@member)
      else
        flash[:notice] = 'Member was successfully created.'
        redirect_to group_member_path(@group, @member)
      end
    end
    fmt.json do
      render :show, status: :ok, location: group_member_path(@group, @member)
    end
  end

  def handle_create_dupe_email(email)
    session[:redirect_uri] = group_join_path(current_group)
    flash[:error] = "Oops! A user with email #{email} already exists." +
                    "Please login to join #{current_group.name}."
    redirect_to new_person_session_path
  end

  def handle_create_error(fmt)
    build_member_resources
    fmt.json { render json: @group.errors, status: :unprocessable_entity }
    fmt.html do
      if is_signup_form?
        render "signup_form_#{@signup_mode}", layout: 'signup'
      else
        render :new
      end
    end
  end

  def handle_update_success(format)
    format.json { render :show, status: :ok, location: group_member_path(@group, @member) }
    format.html do
      if is_signup_form?
        sign_in_and_redirect_to(@member, group_dashboard_path(@group))
      else
        redirect_to group_member_path(@group, @member),
                    notice: 'Member was successfully updated.'
      end
    end
  end

  def handle_update_error(format)
    format.html { render :edit }
    format.json { render json: @member.errors, status: :unprocessable_entity }
  end
end
