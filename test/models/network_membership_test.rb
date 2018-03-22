require_relative '../test_helper'

class NetworkMembershipTest < ActiveSupport::TestCase
  let(:membership){ network_memberships(:swing_left_ohio_membership) }

  describe "associations" do
    specify { membership.group.must_be_instance_of Group }
    specify { membership.network.must_be_instance_of Network }
  end

  describe "validations" do
    let(:swing_left_new_york){ groups(:swing_left_new_york) }
    let(:swing_left){ networks(:swing_left_network) }
    let(:the_avengers){ networks(:the_avengers) }

    it "forbids duplicate memberships" do
      refute NetworkMembership.new(
        group: swing_left_new_york,
        network: swing_left
      ).valid?
    end

    it "forbids more than one primary membership" do
      refute NetworkMembership.new(
        group: swing_left_new_york,
        network: the_avengers,
        primary: true
      ).valid?
    end
  end
end
