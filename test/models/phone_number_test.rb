require 'test_helper'

class PhoneNumberTest < ActiveSupport::TestCase
  test "basic associations" do
    one = phone_numbers(:one)
    assert one.person
  end

  test "should not save email with no data" do
    phone_number = PhoneNumber.new
    assert_not phone_number.save
  end
end
