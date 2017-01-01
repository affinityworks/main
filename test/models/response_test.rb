require 'test_helper'

class ResponseTest < ActiveSupport::TestCase
  test "basic associations" do
    one = responses(:one)
    assert_kind_of Question, one.question
    assert_kind_of Answer, one.question.answers.first
  end
end
