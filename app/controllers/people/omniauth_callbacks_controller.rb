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

  def handle_error(redirect_path)
    flash[:error] = I18n.t("devise.omniauth_callbacks.failure", kind: @service)
    session["devise.#{@service}_data}"] = @auth
    redirect_to redirect_path
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
    SignupHandlers.for(
      signup_reason: @signup_reason,
      group: current_group,
      subgroup_attrs: @subgroup_attrs,
      auth: @auth,
      controller: self,
      service: @service
    ).handle
  end
end
