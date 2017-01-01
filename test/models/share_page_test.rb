require 'test_helper'

class SharePageTest < ActiveSupport::TestCase
  test "basic associations" do
    one = share_pages(:one)
    assert_kind_of Person, one.creator
    assert_kind_of Person, one.modified_by
    assert_kind_of TwitterShare, one.twitter_shares.first
    assert_kind_of FacebookShare, one.facebook_shares.first
    assert_kind_of EmailShare, one.email_shares.first
  end
end
