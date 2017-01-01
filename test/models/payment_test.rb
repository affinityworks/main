require 'test_helper'

class PaymentTest < ActiveSupport::TestCase
  test "basic associations" do
    one = payments(:one)
    assert_kind_of Donation, one.donation
  end
end
