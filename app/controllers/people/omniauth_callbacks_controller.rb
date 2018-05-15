class People::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  AUTH_ACTIONS = %w[login signup].freeze
  SIGNUP_REASONS = %w[create_group join_group].freeze
  before_action :set_auth
  before_action :set_auth_action
  before_action :set_signup_reason
  before_action :set_subgroup_attrs

  def facebook
    @service = "facebook"
    send @auth_action
  end

  def google_oauth2
    @service = "google"
    send @auth_action
  end

  private

  ###########
  # SETTERS #
  ###########

  def set_auth
    @auth = request.env.fetch("omniauth.auth", {}).except(:extra)
  end

  def set_auth_action
    @auth_action = AUTH_ACTIONS.dup.delete(
      request.env.dig("omniauth.params", "auth_action") || 'login'
    )
  end

  def set_signup_reason
    @signup_reason = SIGNUP_REASONS.dup.delete(
      request.env.dig("omniauth.params", "signup_reason")
    )
  end

  def set_subgroup_attrs
    if json = request.env.dig("omniauth.params", "subgroup_json")
      @subgroup_attrs = JSON.parse(json).to_h
    end
  end

  ###########
  # ACTIONS #
  ###########

  def login
    if @person = Person.from_oauth_login(@auth, current_person)
      sign_in_and_redirect @person, event: :authentication #throws if @person not activated
      set_flash_message(:notice, :success, kind: @service) if is_navigational_format?
    else
      handle_error new_person_session_url
    end
  end

  def signup
    if @person = Person.find_by_email(@auth.info.email)
      handle_existing_person
    elsif @person = Person.build_from_oauth_signup(@auth)
      handle_new_person
    else
      handle_error group_join_path(current_group)
    end
  end

  ###########
  # HELPERS #
  ###########

  def handle_new_person
    case @signup_reason
    when 'join_group'
      redirect_to new_group_member_path(signup_mode: @service,
                                        group_id: current_group.id,
                                        person: { oauth: encrypt_token(@auth) })
    when 'create_group'
      redirect_to group_subgroups_path(signup_mode: @service,
                                       group_id: current_group.id,
                                       subgroup: @subgroup_json,
                                       person: { oauth: encrypt_token(@auth) })
    end
  end

  def handle_existing_person
    return handle_existing_member if is_existing_member?
    return handle_missing_contact_info if @person.missing_contact_info?
    handle_simple_signup
  end

  def is_existing_member?
    @person.is_member_of? current_group && @signup_reason == 'join_group'
  end

  def handle_existing_member
    flash[:notice] = "You are already a member of #{current_group.name}"
    sign_in_and_redirect_to(@person, group_dashboard_path(current_group))
  end

  def handle_missing_contact_info
    sign_in_and_redirect_to(
      @person,
      edit_group_member_path(
        signup_mode: @service,
        group_id: current_group.id,
        id: @person.id,
        person: {
          oauth: encrypt_token(@auth)
        }
      )
    )
  end

  def handle_simple_signup
    update_person
    sign_in_and_redirect_to(@person, group_dashboard_path(current_group))
  end

  def update_person
    @person.update_from_oauth_signup(
      @auth,
      { memberships:
          @person.memberships << Membership.create!(group: current_group,
                                                    person: @person,
                                                    role: 'member') }
    )
  end

  def handle_error(redirect_url)
    flash[:error] = I18n.t("devise.omniauth_callbacks.failure", kind: @service)
    session["devise.#{@service}_data}"] = @auth
    redirect_to redirect_url
  end

  def encrypt_token(auth)
    auth.merge(
      'credentials' => {
        'token' => Crypto.encrypt_to_nacl_secret(auth.credentials.token)
      }
    )
  end
end
