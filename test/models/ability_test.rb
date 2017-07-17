require 'test_helper'

class AbilityTest < ActiveSupport::TestCase
  test 'can read ONLY current group\'s events' do
    current_person = Person.first
    current_group = Group.first
    group_event = Event.first
    ability = Ability.new(current_person, current_group)

    assert ability.can? :read, group_event, 'current person is able to read current group\'s events'
    assert_not ability.can? :read, Event.last, 'current person is not able to read current group\'s events'
  end

  test 'can read ONLY current group\'s people' do
    current_person = Person.first
    current_group = Group.first

    ability = Ability.new(current_person, current_group)

    assert ability.can? :read, current_person, 'current person is able to read current group\'s people'
    assert_not ability.can? :read, Person.last, 'current person is not able to read current group\'s people'
  end

  test 'can read ONLY current group\'s attendances' do
    current_person = Person.first
    current_group = Group.first
    group_attendance = Attendance.first
    ability = Ability.new(current_person, current_group)

    assert ability.can? :read, group_attendance, 'current person is able to read current group\'s attendances'
    assert_not ability.can? :read, Attendance.last, 'current person is not able to read current group\'s attendances'
  end

  test 'can manage current group' do
    organizer = Membership.organizer.first.person
    current_group = Membership.organizer.first.group
    ability = Ability.new(organizer, current_group)
    assert ability.can? :manage, Group, 'the user can manage current group if has role organizer'
  end

  test 'can not manage current group' do
    member = Membership.member.first.person
    current_group = Membership.member.first.group
    ability = Ability.new(member, current_group)
    assert_not ability.can? :manage, current_group, 'the user can manage current group if has role member'
  end

  test 'admin can manage ANY group' do
    admin = people(:admin)
    group = groups(:two)
    current_group = groups(:test)
    ability = Ability.new(admin, current_group)
    assert ability.can? :manage, group, 'the user can manage the group'
  end

  test 'organizer can manage it\'s groups' do
    organizer = people(:organizer)
    current_group = groups(:test)
    ability = Ability.new(organizer, current_group)
    assert ability.can? :manage, current_group, 'the organizer can manage the group'
  end

  test 'organizer can manage affiliates groups' do
    organizer = people(:organizer)
    current_group = groups(:test)
    group = groups(:fourth)
    ability = Ability.new(organizer, current_group)
    assert ability.can? :manage, group, 'the organizer can manage affiliate group'
  end

 #changed to cannot, because this is really what we should be hoping for
 #this is passing as cannot, was passing as can prior to permissions update
  test 'organizer can not manage other groups membership roles' do
    organizer = people(:organizer)
    current_group = groups(:test)
    member = Membership.new(group_id: 3,  person_id: 4, role: 0)
    ability = Ability.new(organizer, current_group)
    assert ability.cannot?(:update, member.update(role: 1))
  end

#this should return truthy, permissions error seems to be a reality
  test 'organizer can manage own groups membership roles' do
    organizer = people(:organizer)
    current_group = groups(:test)
    member = Membership.new(group_id: 3,  person_id: 4, role: 0)
    ability = Ability.new(organizer, current_group)
    assert ability.can?(:update, member.update(role: 1))
  end

#this should return truthy
  test 'admin can manage other groups membership roles' do
    admin = people(:admin)
    current_group = groups(:one)
    member = Membership.new(group_id: 3,  person_id: 4, role: 0)
    ability = Ability.new(admin, current_group)
    assert ability.can?(:update, member.update(role: 1))
  end

  test 'organizer can not manage not affiliate group' do
    organizer = people(:organizer)
    current_group = groups(:test)
    group = groups(:two)
    ability = Ability.new(organizer, current_group)
    assert_not ability.can? :manage, group, 'the organizer can not manage not affiliate group'
  end
end
