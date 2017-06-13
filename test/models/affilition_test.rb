require 'test_helper'

class AffiliationTest < ActiveSupport::TestCase
  test "basic group affiliation associations" do
    #one = affiliations(:one)

    #assert_kind_of Group, one.group
    #assert_kind_of Person, one.person
    #assert_kind_of Membership, one.person.memberships.first
    #assert_kind_of Membership, one.group.memberships.first

    #assert_kind_of Group, one.person.groups.first

    #assert_kind_of Person, one.group.members.first
  end

  test 'when duplicated membership' do
    #other_group = group(:test)
    #group = groups(:one)

    #membership = Affiliation.create(affiliate: other_group, group: group)
    #duplicated_membership = Affiliation.new(affiliate: affiliate, group: group)

    #assert_not duplicated_membership.save
  end

  test '#organizer' do
    #organizers = Affiliation.where(role: 'organizer')
    #assert_equal Affiliation.organizer, organizers
  end

  test '#member' do
    #members = Affiliation.where(role: 'member')
    #assert_equal Affiliation.member, members
  end
end
