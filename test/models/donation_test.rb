require 'test_helper'

class DonationTest < ActiveSupport::TestCase
  test "basic associations" do
    one = donations(:one)
    assert_kind_of Person, one.person
    assert_kind_of ReferrerData, one.referrer_data
    assert_kind_of FundraisingPage, one.fundraising_page
    assert_kind_of Attendance, one.attendance
    assert_kind_of Payment, one.payment
    assert_kind_of Recipient, one.recipient
  end
end
