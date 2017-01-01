require 'test_helper'

class FundraisingPageTest < ActiveSupport::TestCase
  test "basic associations" do
    one = fundraising_pages(:one)
    assert_kind_of Person, one.creator
    assert_kind_of Donation, one.donations.first
  end
end
