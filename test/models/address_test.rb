require 'test_helper'

class AddressTest < ActiveSupport::TestCase
  test "basic associations" do
    one = addresses(:one)
    assert one.person
    assert one.location
  end

end
