class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :current_group

  def current_user
    current_person
  end

  def current_group
    current_person.groups.first
  end

  def validate_admin_permission
    return if controller_name == 'sessions' || current_person.nil?
    render_not_found unless current_person.admin?
  end

  def after_sign_in_path_for(resource)
    if session[:redirect_uri]
      session[:redirect_uri]
    elsif resource.admin?
      admin_dashboard_path
    elsif can? :manage, current_group
      members_path
    else
      group_url(id: current_group.id)
    end
  end

  def authorize_group_access
    authorize! :manage, current_group
  end

  rescue_from CanCan::AccessDenied do |exception|
    flash[:alert] = "Access denied. You are not authorized to access the requested page."
    redirect_to root_path
  end

  private

  def render_not_found
    respond_to do |format|
      format.html { render file: "#{Rails.root}/public/404", layout: false, status: :not_found }
      format.xml  { head :not_found }
      format.any  { head :not_found }
    end
  end

  def current_ability
    @current_ability ||= Ability.new(current_user, current_group)
  end

  def json_request?
    request.format.json?
  end
end
