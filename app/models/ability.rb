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

      can :manage, Person do |person|
        permitted_flag = false
        permitted_flag = true if person == current_user
        permitted_flag = true if Membership.organizer.exists?(group: current_group, person: current_user)

        current_group.affiliated_with.each do |affilated_group|
          if permitted_flag == false && Membership.organizer.exists?(person: current_user, group: affilated_group)
            permitted_flag = true
          end
        end
        permitted_flag
      end

      can :read, Attendance do |attendance|
        attendance.person.groups.include?(current_group)
      end

      can :read, Group do |group|
        group&.member?(current_user) || group&.volunteer?(current_user) ||
        group.affiliation_with_role(current_user, Membership.roles[:member]) ||
        group.affiliation_with_role(current_user, Membership.roles[:volunteer])
      end

      can :read, Membership do |membership|
        current_group&.volunteer?(current_user) ||
        current_group.affiliation_with_role(current_user, Membership.roles[:volunteer])
      end

      can :manage, Group do |group|

        permitted_flag = false
        permitted_flag = true if current_user.admin?
        permitted_flag = true if Membership.organizer.exists?(person: current_user, group: group)
        permitted_flag = true if (Membership.organizer.exists?(person: current_user, group: current_group) && current_group.affiliates.include?(group))

        group.affiliated_with.each do |affilated_group|
          if permitted_flag == false && Membership.organizer.exists?(person: current_user, group: affilated_group)
            permitted_flag = true
          end
        end

        permitted_flag
      end

      can :manage, Membership do |membership|
        group = membership.group
        permitted_flag = false
        permitted_flag = true if current_user.admin?
        permitted_flag = true if Membership.organizer.exists?(person: current_user, group: group)
        permitted_flag = true if (Membership.organizer.exists?(person: current_user, group: current_group) && current_group.affiliates.include?(group))

        group.affiliated_with.each do |affilated_group|
          if permitted_flag == false && Membership.organizer.exists?(person: current_user, group: affilated_group)
            permitted_flag = true
          end
        end
        permitted_flag

        #current_user.admin? ||  Membership.organizer.exists?(person: current_user, group: group) ||
        # (Membership.organizer.exists?(person: current_user, group: current_group) && current_group.affiliates.include?(group))
      end

    end
  end
end
