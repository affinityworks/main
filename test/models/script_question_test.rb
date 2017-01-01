require 'test_helper'

class ScriptQuestionTest < ActiveSupport::TestCase
  test "basic associations" do
    one = script_questions(:one)
    assert_kind_of Question, one.question
    assert_kind_of Script, one.script
  end
end
