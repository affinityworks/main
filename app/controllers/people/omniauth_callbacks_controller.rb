class People::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :set_auth
  before_action :set_auth_mode
  before_action :set_group_id

  def facebook
    auth "facebook"
  end

  def google_oauth2
    auth "google"
  end

  private

  def set_auth
    @auth = request.env["omniauth.auth"].except(:credentials, :extra)
  end

  def set_auth_mode
    @auth_mode = request.env.dig("omniauth.params", "auth_mode")
  end

  def set_group_id
    @group_id = request.env.dig("omniauth.params", "group_id")
  end

  def auth(service)
    send @auth_mode, service
  end

  def signup(service)
    if @person = Person.from_oauth_signup(@auth)
      redirect_to new_group_member_path(
                    signup_mode: service,
                    group_id: @group_id,
                    person: { auth: @auth }
                  )
    end
  end

  def login(service)
    if @person = Person.from_oauth_login(request.env["omniauth.auth"], current_person)
      sign_in_and_redirect @person, event: :authentication #throws if @person not activated
      set_flash_message(:notice, :success, kind: service) if is_navigational_format?
    else
      flash[:error] = I18n.t("devise.omniauth_callbacks.failure", kind: service)
      session["devise.#{service}_data}"] = request.env["omniauth.auth"].except(:extra)
      redirect_to new_person_session_url
    end
  end
end
