require 'test_helper'

class ReferrerDataTest < ActiveSupport::TestCase
  test "basic associations" do
    one = referrer_data(:one)
    assert_kind_of Donation, one.donation
    assert_kind_of Outreach, one.outreach
    assert_kind_of Signature, one.signature
  end

end
