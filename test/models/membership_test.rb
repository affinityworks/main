require 'test_helper'

class MembershipTest < ActiveSupport::TestCase
  test "basic person associations" do
    one = memberships(:one)

    assert_kind_of Group, one.group
    assert_kind_of Person, one.person
    assert_kind_of Membership, one.person.memberships.first
    assert_kind_of Membership, one.group.memberships.first

    assert_kind_of Group, one.person.groups.first

    #assert_kind_of Person, one.group.members.first
  end

  test '#organizer' do
    organizers = Membership.where(role: 'organizer')
    assert_equal Membership.organizer, organizers
  end

  test '#member' do
    members = Membership.where(role: 'member')
    assert_equal Membership.member, members
  end
end
