require_relative '../test_helper'

class NetworkMembershipTest < ActiveSupport::TestCase
  let(:membership){ network_memberships(:ohio_chapter_membership) }

  describe "associations" do
    specify { membership.group.must_be_instance_of Group }
    specify { membership.network.must_be_instance_of Network }
  end

  describe "validations" do
    let(:new_york_chapter){ groups(:new_york_chapter) }
    let(:national_network){ networks(:national_network) }
    let(:the_avengers){ networks(:the_avengers) }

    it "forbids duplicate memberships" do
      refute NetworkMembership.new(
        group: new_york_chapter,
        network: national_network
      ).valid?
    end

    it "forbids more than one primary membership" do
      refute NetworkMembership.new(
        group: new_york_chapter,
        network: the_avengers,
        primary: true
      ).valid?
    end
  end
end
