require 'test_helper'

class ScriptTest < ActiveSupport::TestCase
  test "basic associations" do
    one = scripts(:one)
    assert_kind_of Person, one.creator
    assert_kind_of Person, one.modified_by
    assert_kind_of CanvassingEffort, one.canvassing_effort
    assert_kind_of Question, one.questions.first
  end
end
