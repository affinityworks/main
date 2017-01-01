require 'test_helper'

class PetitionTest < ActiveSupport::TestCase
  test "basic associations" do
    one = petitions(:one)
    assert_kind_of Target, one.targets.first
    assert_kind_of Signature, one.signatures.first
    assert_kind_of Person, one.creator
    assert_kind_of Person, one.modified_by
  end
end
