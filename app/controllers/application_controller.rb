class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :current_group

  def current_user
    current_person
  end

  def current_group
    #TODO: Add selected group
    if current_person.kind_of?(Person)
       current_person.groups.first
    else #NOTE Hack until we figure out the relation between Groups and API::Users or OAuth users
      Group.first
    end
  end

  private

  def current_ability
    @current_ability ||= Ability.new(current_user, current_group)
  end
end
