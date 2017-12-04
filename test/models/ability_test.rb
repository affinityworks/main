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

  test 'organizer can managed multi level affiliated group' do
    national_organizer = people(:national_organizer)

    ability = Ability.new(national_organizer, groups(:national))
    assert ability.can?( :manage, groups(:national)), 'the organizer can manage affiliate group'
    assert ability.can?( :manage, groups(:state)), 'the organizer can manage affiliate group'
    assert ability.can?( :manage, groups(:district)), 'the organizer can manage affiliate group'
    assert ability.can?( :manage, groups(:regional)), 'the organizer can manage affiliate group'
    assert ability.can?( :manage, groups(:city)), 'the organizer can manage affiliate group'
    assert ability.can?(:manage, groups(:national).memberships.first)
    assert ability.can?(:manage, groups(:state).memberships.first)
    assert ability.can?(:manage, groups(:district).memberships.first)
    assert ability.can?(:manage, groups(:regional).memberships.first)
    assert ability.can?(:manage, groups(:city).memberships.first)
  end

  test 'organizer can not manage other groups membership roles' do
    person = people(:one)
    current_group = groups(:test)
    membership = memberships(:member1)
    ability = Ability.new(person, current_group)
    assert ability.cannot?(:update, membership)
  end

#this should return truthy, permissions error seems to be a reality
  test 'organizer can manage own groups membership roles' do
    organizer = people(:organizer)
    current_group = groups(:test)
    membership = memberships(:member1)
    ability = Ability.new(organizer, current_group)
    assert ability.can?(:manage, current_group)
    assert ability.can?(:manage, membership)
  end

#this should return truthy
  test 'admin can manage other groups membership roles' do
    admin = people(:admin)
    current_group = groups(:two)
    membership = memberships(:member2)
    ability = Ability.new(admin, current_group)
    assert ability.can?(:manage, current_group)
    assert ability.can?(:manage, membership)
  end

  test 'organizer can not manage not affiliate group' do
    organizer = people(:organizer)
    current_group = groups(:test)
    group = groups(:two)
    ability = Ability.new(organizer, current_group)
    assert_not ability.can? :manage, group, 'the organizer can not manage not affiliate group'
  end

  test 'members can read current group' do
    person = people(:one)
    current_group = person.groups.first

    ability = Ability.new(person, current_group)
    assert ability.can?(:read, current_group)
    assert ability.cannot?(:manage, current_group)
  end

  test 'members cannot read others groups' do
    person = people(:one)
    current_group = groups(:two)

    ability = Ability.new(person, current_group)
    assert ability.cannot?(:read, current_group)
  end

  test 'members can read affiliates groups' do
    current_group = groups(:test)
    group = groups(:fourth)
    person = people(:member1)

    ability = Ability.new(person, current_group)
    assert ability.can? :read, group
    assert ability.cannot?(:manage, current_group)
  end
end
