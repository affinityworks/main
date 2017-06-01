class Ability
  include CanCan::Ability

  def initialize(person, current_group=nil)
    if person
      can :read, Event do |event|
        event.groups.include?(current_group)
      end

      can :read, Person do |person|
        person.groups.include?(current_group)
      end

      can :read, Attendance do |attendance|
        attendance.person.groups.include?(current_group)
      end

      can :manage, Group do
        return true if person.admin?
        person.memberships.any_organizer.collect(&:group).include?(current_group)
      end
    end
  end
end
