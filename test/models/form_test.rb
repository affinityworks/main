require 'test_helper'

class FormTest < ActiveSupport::TestCase
  test "basic associations" do
    one = forms(:one)
    assert_kind_of Person, one.person
    assert_kind_of Person, one.creator
    assert_kind_of Submission, one.submissions.first
  end
end
