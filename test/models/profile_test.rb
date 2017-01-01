require 'test_helper'

class ProfileTest < ActiveSupport::TestCase
  test "basic associations" do
    one = profiles(:one)
    assert_kind_of Person, one.person
  end
end
