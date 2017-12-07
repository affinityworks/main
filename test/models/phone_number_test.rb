require 'test_helper'

class PhoneNumberTest < ActiveSupport::TestCase
  TEST_SAMPLES = {
    "(123) 456-7890" => true,
    "+1-123-456-7890" => true,
    "123-456-7890" => true,
    "123456-7890" => false,
    "" => false,
    "1212sdfsd2121" => false,
    "(12)" => false,
    "this is a #%(%& garbage string 31" => false,
    "this is a garbage string 318" => false,
    "1212/1212" => false
  }

  TEST_SAMPLES.each do |test_case, expectation|
    test "on '#{test_case}'' should be #{expectation ? 'valid' : 'invalid'}" do
      phone_number = PhoneNumber.new(:number => test_case)
      if expectation 
        assert phone_number.valid?
      else
        assert_not phone_number.valid?
      end
    end
  end

  test "basic associations" do
    one = phone_numbers(:one)
    assert one.person
  end

  test "should not save phone number with no data" do
    phone_number = PhoneNumber.new
    assert_not phone_number.valid?
  end
end