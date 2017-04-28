class Ability
  include CanCan::Ability

  def initialize(person)
    if person
      can :read, :all
    end
  end
end
