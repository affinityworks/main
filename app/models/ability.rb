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

      can :manage, Group do |group|
        current_user.admin? ||  Membership.organizer.exists?(person: current_user, group: group) || 
          (Membership.organizer.exists?(person: current_user, group: current_group) && current_group.affiliates.include?(group))
      end
    end
  end
end
