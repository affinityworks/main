require_relative "../../test_helper"

class NetworkableTest < ActiveSupport::TestCase
  let(:ohio_chapter){ groups(:ohio_chapter) }
  let(:national_network){ networks(:national_network) }
  let(:the_avengers){ networks(:the_avengers) }

  describe "associations" do
    specify { ohio_chapter.networks.first.must_be_kind_of Network }
  end

  describe "accessors" do

    it "retrieves networks" do
      ohio_chapter.networks.
        must_equal [ national_network, the_avengers ]
    end

    it "retrieves a primary network" do
      ohio_chapter.primary_network.must_equal national_network
    end
  end

  describe "nested attributes" do
    it "accepts nested attributes for network membership" do
      assert_difference "NetworkMembership.count", 1 do
        Group.create(
          name: 'foogroup',
          network_memberships_attributes: [
            {
              network: networks(:the_avengers),
            }
          ]
        )
      end
    end
  end
end
