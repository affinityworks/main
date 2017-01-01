require 'test_helper'

class TargetTest < ActiveSupport::TestCase
  test "basic associations" do
    one = targets(:one)
    assert_kind_of Outreach, one.outreaches.first
    assert_kind_of Petition, one.petitions.first
  end
end
