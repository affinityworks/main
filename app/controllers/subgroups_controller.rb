class SubgroupsController < ApplicationController
  SIGNUP_MODES = %w[email google facebook].freeze
  before_action :set_group
  before_action :set_signup_mode
  before_action :set_target_action
  before_action :set_oauth, only: %i[oauth_signup create]

  # GET groups/:group_id/subgroups/new
  def new
    @subgroup = Group.build_group_with_organizer
  end

  # POST groups/:group_id/subgroups/signup
  def signup
    @person = Person.build_for_signup
    @subgroup = JSON.generate(subgroup_params.to_h)
    if @signup_mode == 'email'
      render "signup_form_#{@signup_mode}", layout: 'signup'
    else
      redirect_to omniauth_authorize_path(
        :person,
        omniauth_value,
        subgroup_json: JSON.generate(subgroup_params.to_h),
        auth_action:   'signup',
        signup_reason: 'create_group',
        group_id: @group.id
      )
    end
  end

  # GET groups/:group_id/subgroups/oauth_signup
  def oauth_signup
    if current_person&.has_contact_info?
      create_subgroup_with_organizer(current_person.attributes)
    else
      @person = current_person&.prepare_for_contact_update || Person.build_for_signup
      @subgroup = JSON.generate(subgroup_params.to_h)

      render "signup_form_oauth", layout: 'signup'
    end
  end

  # POST groups/:group_id/subgroups
  def create
    if Oauth.is_oauth_signup?(@signup_mode) && current_person.nil?
      @person = Person.create_from_oauth_signup(Oauth.decrypt_token(@oauth), organizer_params)
      organizer_attrs = @person.attributes
      
      return handle_create_error unless @person.valid?
    elsif current_person
      @person = current_person
      @person.update(organizer_params)
      organizer_attrs = @person.attributes

      return handle_create_error unless @person.valid?
    else
      organizer_attrs = organizer_params
    end

    create_subgroup_with_organizer(organizer_attrs)
  end

  private

  def create_subgroup_with_organizer(organizer_attrs)
    @subgroup, @person = @group.create_subgroup_with_organizer(
      subgroup_attrs: subgroup_params,
      organizer_attrs: organizer_attrs
    )

    @subgroup.valid? ? handle_create_success : handle_create_error
  end

  ###########
  # SETTERS #
  ###########

  def set_group
    @group = current_group
  end

  def set_signup_mode
    @signup_mode = SIGNUP_MODES.dup.delete(params[:signup_mode] ||
                                           params[:commit])
  end

  def set_target_action
    @target_action = (!current_person && action_name == 'new') ?
                       'signup' :
                       'create'
  end

  def set_oauth
    @oauth = parse_oauth if Oauth.is_oauth_signup?(@signup_mode)
  end

  ###########
  # OAUTH #
  ###########

  # String | ActionController::Parameters ->
  # OmniAuth::AuthHash | JSONString
  def parse_oauth
    case oauth_params
    when ActionController::Parameters
      JSON.generate(oauth_params.to_h)
    when String
      OmniAuth::AuthHash.new(JSON.parse(oauth_params).to_h)
    when OmniAuth::AuthHash
      oauth_params
    end.as_json
  end

   # TODO: DRY THIS UP!!!!
  # () -> ActionController::Parameters | String
  def oauth_params
    oauth = params.require(:person).require(:oauth)
    case action_name
    when 'new', 'signup', 'oauth_signup' # => ActionController::Parameters
      oauth.permit(:provider,
                   :uid,
                   credentials: [:token, :expires_at, :expires ],
                   info:        [:email, :name, :image ])
    when 'create' # => String
      OmniAuth::AuthHash.new(JSON.parse(oauth).to_h)
    end
  end


  ##########
  # PARAMS #
  ##########

  def subgroup_params
    deserialize(params.require(:subgroup))
      .permit(:name,
              :description,
              :summary,
              location_attributes: [:postal_code])
  end

  def deserialize(maybe_params)
    case maybe_params
    when String # ie: string-serialized JSON
      ActionController::Parameters.new(JSON.parse(maybe_params).to_h)
    when ActionController::Parameters
      maybe_params
    end
  end

  def organizer_params
    base = params[:person] ?
             params.require(:person) :
             params.require(:subgroup).require(:organizer_attributes)
    base
      .permit(:id,
              :given_name,
              :family_name,
              :password,
              phone_numbers_attributes: [:number],
              email_addresses_attributes: [:address],
              personal_addresses_attributes: [:postal_code]
             )
       .tap { |prams| format(prams) }
  end

  def format(params)
    params
      .tap { |p| format_contact_info(p) }
      .tap { |p| handle_empty_contact_info(p) }
  end

  def format_contact_info(params)
    return if current_person # only gather contact info for logged-out users
    [
      'phone_numbers_attributes',  'email_addresses_attributes',  'personal_addresses_attributes'
    ].each do |collection| 
      params.dig(collection, '0').merge!(primary: true) if params.dig(collection, '0')
    end.compact
  end

  def handle_empty_contact_info(params)
    if params.dig('phone_numbers_attributes', '0', 'number')&.empty?
      params.delete('phone_numbers_attributes')
    end
  end

  ##########################
  # ACTION RESULT HANDLERS #
  ##########################

  def handle_create_success
    Subgroups::AfterCreate.call(organizer: @person, subgroup: @subgroup)
    sign_in_and_redirect_to(@person, group_dashboard_path(@subgroup))
  end

  def handle_create_error
    if @signup_mode
      @errors = AggregateError.new(objects: [@person, @subgroup]).errors
      @person = @person || Person.build_for_signup
      @subgroup = JSON.generate(subgroup_params.to_h)
      @oauth = JSON.generate(@oauth)
      render "signup_form_#{signup_mode_form}", layout: 'signup'
    else
      render :new
    end
  end

  ###########
  # HELPERS #
  ###########

  def omniauth_value
    { 
      "facebook" => "facebook",
      "google" => "google_oauth2"
    }[@signup_mode]
  end

  def signup_mode_form
    case @signup_mode
    when "email"
      "email"
    when "facebook", "google"
      "oauth"
    end
  end
end
