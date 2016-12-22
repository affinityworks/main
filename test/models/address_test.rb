require 'test_helper'

class AddressTest < ActiveSupport::TestCase
  test "basic associations" do
    one = addresses(:one)
    assert one.person
    assert one.location
  end

  test "should not save address with no data" do
    address = Address.new
    assert_not address.save
  end
end
