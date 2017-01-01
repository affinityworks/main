require 'test_helper'

class CanvassingEffortTest < ActiveSupport::TestCase
  test "basic associations" do
    one = canvassing_efforts(:one)
    assert_kind_of Script, one.script
    assert_kind_of Person, one.creator
    assert_kind_of Person, one.modified_by
    assert_kind_of Canvass, one.canvasses.first
  end
end
