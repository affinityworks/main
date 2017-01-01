require 'test_helper'

class CanvassTest < ActiveSupport::TestCase
  test "basic associations" do
    one = canvasses(:one)
    assert_kind_of Person, one.canvasser
    assert_kind_of Person, one.target
    assert_kind_of CanvassingEffort, one.canvassing_effort
    assert_kind_of Answer, one.answers.first
  end
end
