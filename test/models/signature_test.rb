require 'test_helper'

class SignatureTest < ActiveSupport::TestCase
  test "basic associations" do
    one = signatures(:one)
    assert_kind_of ReferrerData, one.referrer_data
    assert_kind_of Person, one.person
    assert_kind_of Petition, one.petition
  end
end
