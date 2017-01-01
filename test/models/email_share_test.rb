require 'test_helper'

class EmailShareTest < ActiveSupport::TestCase
  test "basic associations" do
    one = email_shares(:one)
    assert_kind_of SharePage, one.share_page
  end
end
