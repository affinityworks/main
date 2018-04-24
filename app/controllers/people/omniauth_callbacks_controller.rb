class People::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    set_omniauth("facebook")
  end

  def google_oauth2
    set_omniauth("google")
  end

  private

  def set_omniauth(oauth_service)
    @person = Person.from_omniauth(request.env["omniauth.auth"], current_person)
    @group_id = request.env.dig("omniauth.params", "group_id")

    if current_person && current_person == @person && @group_id
      flash[:notice] =  I18n.t("devise.omniauth_callbacks.success", kind: oauth_service)
      redirect_to new_group_import_url(group_id)
    elsif @person
      sign_in_and_redirect @person, :event => :authentication #this will throw if @person is not activated
      set_flash_message(:notice, :success, :kind => oauth_service) if is_navigational_format?
    else
      flash[:error] = I18n.t("devise.omniauth_callbacks.failure", kind: oauth_service)
      session["devise.#{oauth_service}_data}"] = request.env["omniauth.auth"].except(:extra)
      redirect_to new_person_session_url
    end
  end
end
