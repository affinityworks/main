class People::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :set_omniauth
  def facebook
  end

  # def twitter
  # end

  # def google_oauth2
  # end

  private

  def set_omniauth
    @person = Person.from_omniauth(request.env["omniauth.auth"], current_person)
    @group_id = request.env.dig("omniauth.params", "group_id")
    if current_person && current_person == @person && @group_id
      flash[:notice] =  I18n.t("devise.omniauth_callbacks.success", kind: "Facebook")
      redirect_to new_group_import_url(group_id)
    elsif @person
      sign_in_and_redirect @person, :event => :authentication #this will throw if @person is not activated
      set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
    else
      flash[:error] = I18n.t("devise.omniauth_callbacks.failure", kind: "Facebook")
      session["devise.facebook_data"] = request.env["omniauth.auth"].except(:extra)
      redirect_to new_person_session_url
    end
  end

end
