class People::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    @person = Person.from_omniauth(request.env["omniauth.auth"], current_person)

    if @person == current_person
      redirect_to new_import_url, flash: { notice: "Facebook account successfully connected." }
    elsif @person
      sign_in_and_redirect @person, :event => :authentication #this will throw if @person is not activated
      set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      redirect_to new_person_session_url
    end
  end
end
