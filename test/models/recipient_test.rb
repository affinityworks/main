require 'test_helper'

class RecipientTest < ActiveSupport::TestCase
  test "basic associations" do
    one = recipients(:one)
    assert_kind_of Person, one.donation.person
    assert_kind_of Donation, one.donation
  end

end
