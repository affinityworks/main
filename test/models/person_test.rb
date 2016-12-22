require 'test_helper'

class PersonTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "basic person associations" do
    one = people(:one)
    assert_kind_of( Person, one )
    assert one.email_address
    assert one.employer_address
    assert one.personal_addresses.first
    assert one.phone_numbers.first
    assert one.profiles.first
    assert one.employer
  end

  test "should not save person without name" do
    person = Person.new
    assert_not person.save
  end
end
