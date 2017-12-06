module ProfileHelper

  def group_link_helper(group)
    return group_dashboard_path(group) if can_go_to_dashboard?(group)
    group_members_path(group)
  end


  def can_go_to_dashboard?(group)
    can?(:manage, group) || can?(:read, group) && volunteer_permission?(group)
  end

  def volunteer_permission?(group)
    group.volunteer?(current_person) || group.affiliated_volunteer?(current_person)
  end
end

