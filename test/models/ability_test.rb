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
end
