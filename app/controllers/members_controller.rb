class MembersController < ApplicationController
  SIGNUP_MODES = %w[email facebook google].freeze
  # authentication
  before_action :authenticate_person!, except: %i[new create]
  before_action :allow_logged_out_signups, only: %i[new create]
  before_action :authorize_group_access
  # setters
  before_action :set_signup_mode, only: %i[new create edit update]
  before_action :set_oauth, only: %i[new create edit update]
  before_action :set_group
  before_action :set_members, only: :index
  before_action :set_member, only: [:show, :edit, :update, :destroy, :attendances]
  before_action :build_member, only: %i[new create]
  before_action :build_member_resources, only: %i[new edit]
  before_action :set_target, only: %i[new create edit update]

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



  # GET /groups/:id/members/new
  def new
    if is_signup_form?
      render "signup_form_#{@signup_mode}"
    else
      authorize! :manage, @group # dupe of authorize_group_access? (@aguestuser)
    end
  end

  # POST /groups/:id/members/
  # POST /groups/:id/members/.json

  def create
    if is_oauth_signup?
      @member = Person.create_from_oauth_signup(decrypt_token(@oauth), person_params)
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
    if is_signup_form?
      render "signup_form_#{@signup_mode}"
    else
      @groups = Group.all
      authorize! :manage, @group # redundant? (@aguestuser)
    end
  end

  # PATCH/PUT /groups/1
  # PATCH/PUT /groups/1.json
  def update
    respond_to do |format|
      if is_oauth_signup?
        ok = @member.update_from_oauth_signup(decrypt_token(@oauth), person_params)
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
    group = Group.find(params[:group_id]) if params[:group_id]
    person = Person.find(params[:person_id]) if params[:person_id]

    valid_group = (group && group.members.include?(person)) ? group : person.groups.first
    return redirect_to edit_group_member_path(group_id: valid_group.id, id: person.id)
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
    @oauth = parse_oauth if is_oauth_signup?
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

  # OmniAuth::AuthHash -> OmniAuth::AuthHash
  def decrypt_token(oauth_hash)
    if token = oauth_hash.dig('credentials', 'token')
      OmniAuth::AuthHash.new(
        oauth_hash.merge!(
          'credentials' => {
            'token' => Crypto.decrypt_with_nacl_secret(token)
          }
        )
      )
    end
  end

  def allow_logged_out_signups
    authenticate_person! unless is_signup_form?
  end

  def set_group
    @group = current_group # this is dumb (@aguestuser)
  end

  def set_member
    if is_oauth_signup?
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

  def set_members
    member_ids = Membership.where(:group_id =>@group.affiliates.pluck(:id).push(@group.id) ).pluck(:person_id)

    @members = Person.where(:id => member_ids).includes(
        [:email_addresses, :personal_addresses, :phone_numbers]
      ).page(params[:page])

    if params[:filter]
      @members = @members.where('given_name ilike ? or family_name ilike ?', "%#{params[:filter]}%","%#{params[:filter]}%")
    elsif params[:email]
      @members = @members.by_email(params[:email])
    end

    if params[:sort]
      @members = @members.order(params[:sort] => params[:direction])
    end
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
    if action_name == 'new' && is_oauth_signup?
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

  def is_oauth_signup?
    %w[facebook google].include?(@signup_mode)
  end

  def is_email_signup?
    @signup_mode == 'email'
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
    fmt.html { render is_signup_form? ? "signup_form_#{@signup_mode}" : :new }
    fmt.json { render json: @group.errors, status: :unprocessable_entity }
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
