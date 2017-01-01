require 'test_helper'

class TwitterShareTest < ActiveSupport::TestCase
  test "basic associations" do
    one = twitter_shares(:one)
    assert_kind_of SharePage, one.share_page
  end
end
