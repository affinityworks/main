require_relative "../../test_helper"

class NetworkableTest < ActiveSupport::TestCase
  let(:swing_left_ohio){ groups(:swing_left_ohio) }
  let(:swing_left){ networks(:swing_left_network) }
  let(:the_avengers){ networks(:the_avengers) }

  describe "associations" do
    specify { swing_left_ohio.networks.first.must_be_kind_of Network }
  end

  describe "accessors" do

    it "retrieves networks" do
      swing_left_ohio.networks.
        must_equal [ swing_left, the_avengers ]
    end

    it "retrieves a primary network" do
      swing_left_ohio.primary_network.must_equal swing_left
    end
  end
end
