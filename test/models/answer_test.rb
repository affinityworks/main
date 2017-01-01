require 'test_helper'

class AnswerTest < ActiveSupport::TestCase
  test "basic associations" do
    one = advocacy_campaigns(:one)
    assert_kind_of Person, one.creator
    assert_kind_of Person, one.modified_by
  end
end
