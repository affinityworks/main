module ProfileHelper

  def group_link_helper(group)
    can?( :manage, group) ? group_dashboard_path(group) : group_path(group)
 
  end
end

