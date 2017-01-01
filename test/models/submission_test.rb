require 'test_helper'

class SubmissionTest < ActiveSupport::TestCase
  test "basic associations" do
    one = submissions(:one)
    assert_kind_of ReferrerData, one.referrer_data
    assert_kind_of Form, one.form
    assert_kind_of Person, one.person
  end
end
