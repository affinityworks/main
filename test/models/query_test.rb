require 'test_helper'

class QueryTest < ActiveSupport::TestCase
  test "basic associations" do
    one = queries(:one)
    assert_kind_of Person, one.creator
    assert_kind_of Person, one.modified_by
  end
end
