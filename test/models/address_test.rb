require 'test_helper'

class AddressTest < ActiveSupport::TestCase

  test "basic associations" do
    one = addresses(:one)
    assert one.person
    assert one.location
  end

  test "validations" do
    Address.new.wont have_valid(:region).when("FOOO")
    Address.new.must have_valid(:region).when("AL")
    Address.new.must have_valid(:region).when("PR")
  end

end
