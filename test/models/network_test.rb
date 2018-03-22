require_relative '../test_helper'

class NetworkTest < ActiveSupport::TestCase
  let(:network){ networks(:swing_left_network) }

  describe "associations"do
    specify { network.members.first.must_be_instance_of Group }
  end

  describe "validations" do
    it "forbids dupe names" do
      refute Network.new(name: network.name).valid?
    end

    it "forbids changing name from original value" do
      network.assign_attributes(name: "new name")
      refute network.valid?
    end
  end
end
