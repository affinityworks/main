class People::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :set_auth
  before_action :set_auth_mode

  def facebook
    @service = "facebook"
    send @auth_mode
  end

  def google_oauth2
    @service = "google"
    send @auth_mode
  end

  private

  ###########
  # HELPERS #
  ###########

  def set_auth
    @auth = request.env.fetch("omniauth.auth", {}).except(:extra)
  end

  def set_auth_mode
    @auth_mode = request.env.dig("omniauth.params", "auth_mode") || 'login'
  end

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

  #####################
  # SECONDARY HELPERS #
  #####################

  def handle_new_person
    redirect_to new_group_member_path(signup_mode: @service,
                                      group_id: current_group.id,
                                      person: { oauth: encrypt_token(@auth) })
  end

  def handle_existing_person
    return handle_existing_member if @person.is_member_of? current_group
    return handle_missing_contact_info if @person.missing_contact_info?
    handle_simple_signup
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
