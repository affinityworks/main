class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :current_group

  def current_user
    current_person
  end

  def current_group
    current_person.groups.first #TODO: Add selected group
  end
end
