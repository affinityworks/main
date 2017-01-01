require 'test_helper'

class FacebookShareTest < ActiveSupport::TestCase
  test "basic associations" do
    one = facebook_shares(:one)
    assert_kind_of SharePage, one.share_page
  end
end
