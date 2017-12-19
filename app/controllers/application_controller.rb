class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :set_paper_trail_whodunnit
  helper_method :current_group, :current_role

  def current_user
    current_person
  end

  def current_group
    group_id = controller_name == 'groups' ? params[:id] : params[:group_id]
    Group.find(group_id) if group_id
  end

  def current_role
    return '' unless current_person && current_group
    organizer = Membership.roles[:organizer]
    return 'organizer' if current_group.affiliation_with_role(current_user, organizer)
    volunteer = Membership.roles[:organizer]
    return 'volunteer' if current_group.affiliation_with_role(current_user, volunteer)
    current_person.role_in_group(current_group) || 'member'
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
      group_dashboard_path(current_group.id)
    else
      profile_index_path
    end
  end

  def authorize_group_access
    return unless current_group
    authorize! :read, current_group && return if volunteer_permission?
    authorize! :read, current_group && return if authorized_controllers_and_actions?
    authorize! :manage, current_group
  end

  def volunteer_permission?
    current_group.volunteer?(current_person) ||
    current_group.affiliation_with_role(current_user, Membership.roles[:volunteer])
  end

  def authorized_controllers_and_actions?
    controller_names = %w(members memberships events)
    controller_names.include?(controller_name) && action_name == 'index'
  end

  rescue_from CanCan::AccessDenied do |_exception|
    respond_to do |format|
      format.html do
        flash[:alert] = 'Access denied. You are not authorized to access the requested page.'
        redirect_to profile_index_path
      end
      format.json { head :forbidden }
    end
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

  def direction_param
    return unless params[:direction]
    @direction_param ||= ['asc', 'desc'].delete(params[:direction])
  end
end
