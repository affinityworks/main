require 'test_helper'

class AddressTest < ActiveSupport::TestCase

  test "basic associations" do
    one = addresses(:one)
    assert one.person
    assert one.location
  end

  describe "validations" do

    let(:address){ Address.new }

    it "requires region to be valid state abbreviation or empty" do
      address.wont have_valid(:region).when("FOOO")

      address.must have_valid(:region).when("AL")
      address.must have_valid(:region).when("PR")
      address.must have_valid(:region).when("")
      address.must have_valid(:region).when(nil)
    end

    it "requires postal code to be numeric with dashes" do
      address.wont have_valid(:postal_code).when("hahaha lols")

      address.must have_valid(:postal_code).when("90210")
      address.must have_valid(:postal_code).when("90210-123")
      address.must have_valid(:postal_code).when("")
      address.must have_valid(:postal_code).when(nil)
    end
  end
end
