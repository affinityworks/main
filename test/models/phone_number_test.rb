require 'test_helper'

class PhoneNumberTest < ActiveSupport::TestCase
  test "basic associations" do
    one = phone_numbers(:one)
    assert one.person
  end

  test "should not save phone number with no data" do
    phone_number = PhoneNumber.new
    assert_not phone_number.save
  end

  test "should save phone_number with just a number" do
    phone_number = PhoneNumber.new(:number => '234234234')
    assert phone_number.save
  end
end
