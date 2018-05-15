class SubgroupsController < ApplicationController
  SIGNUP_MODES = %w[email google facebook].freeze
  before_action :set_group
  before_action :set_signup_mode
  before_action :set_target_action

  # GET groups/:group_id/subgroups/new
  def new
    @subgroup = Group.build_group_with_organizer
  end

  # GET groups/:group_id/subgroups/signup
  def signup
    @person = Person.build_for_signup
    @subgroup = JSON.generate(subgroup_params.to_h)
    if @signup_mode == 'email'
      render "signup_form_#{@signup_mode}", layout: 'signup'
    else
      redirect_to omniauth_authorize_path(
        :person,
        @signup_mode,
        subgroup_json: JSON.generate(subgroup_params.to_h),
        auth_action:   'signup',
        signup_reason: 'create_group'
      )
    end
  end

  # POST groups/:group_id/subgroups
  def create
    if is_oauth_signup?
      @person = Person.create_from_oauth_signup(decrypt_token(@oauth),organizer_params)
      organizer_attrs = @person.attributes
    else
      organizer_attrs = organizer_params
    end
    @subgroup, @person = @group.create_subgroup_with_organizer(
      subgroup_attrs: subgroup_params,
      organizer_attrs: organizer_attrs
    )
    @subgroup.valid? ? handle_create_success : handle_create_error
  end

  private

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

  # TODO: dry this!
  def set_oauth
    @oauth = oauth_params if is_oauth_signup?
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

  # TODO: DRY THIS UP!!!!
  # () -> ActionController::Parameters | String
  def oauth_params
    oauth = params.require(:person).require(:oauth)
    case action_name
    when 'new', 'signup' # => ActionController::Parameters
      oauth.permit(:provider,
                   :uid,
                   credentials: [:token, :expires_at, :expires ],
                   info:        [:email, :name, :image ])
    when 'create' # => String
      OmniAuth::AuthHash.new(JSON.parse(oauth).to_h)
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

  def format(prams)
    prams
      .tap { |p| format_contact_info(p) }
      .tap { |p| handle_empty_contact_info(p) }
  end

  def format_contact_info(prams)
    return if current_person # only gather contact info for logged-out users
    [
      'phone_numbers_attributes',
      'email_addresses_attributes',
      'personal_addresses_attributes'
    ].each { |collection| prams.dig(collection, '0').merge!(primary: true) }
  end

  def handle_empty_contact_info(prams)
    if prams.dig('phone_numbers_attributes', '0', 'number')&.empty?
      prams.delete('phone_numbers_attributes')
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
      @person = @subgroup.memberships.first.person
      @subgroup = JSON.generate(subgroup_params.to_h)
      render "signup_form_#{@signup_mode}", layout: 'signup'
    else
      render :new
    end
  end

  ###########
  # HELPERS #
  ###########

  # TODO: DRY THIS!
  def is_oauth_signup?
    %[facebook google].include? @signup_mode
  end

  # TODO: DRY THIS!
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
end
