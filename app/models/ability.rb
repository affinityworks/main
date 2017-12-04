class Ability
  include CanCan::Ability

  def initialize(current_user, current_group=nil)
    if current_user
      can :read, Event do |event|
        event.groups.include?(current_group)
      end

      can :read, Person do |person|
        person.groups.include?(current_group)
      end

      can :read, Attendance do |attendance|
        attendance.person.groups.include?(current_group)
      end

      can :read, Group do |group|
        group.member?(current_user) || group.affiliated_member?(current_user)
      end

      can :manage, Group do |group|
        check_manage_for_group(current_user, group)
      end

      can :manage, Membership do |membership|
        group = membership.group
        check_manage_for_group(current_user, group)
      end

    end
  end

  def check_manage_for_group(current_user, group, current_group=nil)
    permitted_flag = false
    permitted_flag = true if current_user.admin? 
    permitted_flag = true if Membership.organizer.exists?(person: current_user, group: group)
    permitted_flag = true if (Membership.organizer.exists?(person: current_user, group: current_group) && current_group.affiliates.include?(group))
    
    if permitted_flag == false
      group.affiliated_with.each do |affiliated_group|
        permitted_flag ||= check_affiliated_group(current_user, affiliated_group)
      end
    end
    return permitted_flag
  end

  def check_affiliated_group(user, group)
    permitted_flag = false

    if Membership.organizer.exists?(person: user, group: group)
      permitted_flag =  true
    else
      group.affiliated_with.each do |next_level_affiliated_with|
        permitted_flag ||= check_affiliated_group(user, next_level_affiliated_with)
      end
    end

    return permitted_flag
  end
end
