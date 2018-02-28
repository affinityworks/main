require 'test_helper'

class PhoneNumberTest < ActiveSupport::TestCase

  VALID_PHONE_NUMBERS = [
    "(734) 555 1212",
    "(734) 555.1212",
    "(734) 555-1212",
    "(734) 5551212",
    "(734)5551212",
    "734 555 1212",
    "734.555.1212",
    "734-555-1212",
    "7345551212",
    "+1-123-456-7890",
    "+1 123-456-7890",
    "+43-123-456-7890",
    "+43 123-456-7890",
    "123456-7890",
  ]

  INVALID_PHONE_NUMBERS = [
    "", # duh
    "345551212", # too few characters
    "(34) 555 1212", # that's not a real area code!
    "734-555-1212 ext 2", # no alphabetic characters!
    "7345551212!", # no special characters!
    "+433 123-456-7890", # country codes only have 2 digits!
    "1212sdfsd2121", # what did we say about alphabetic characters?
    "(12)", # this is just weird
    "this is a #%(%& garbage string 31", # this too
    "this is a garbage string 318", # yup
    "1212/1212", # i don't know why we even tested this one
  ]

  it "allows valid phone numbers" do
    VALID_PHONE_NUMBERS.each do |number|
      PhoneNumber.new.must have_valid(:number).when(number)
    end
  end

  it "rejects invalid phone numbers" do
    INVALID_PHONE_NUMBERS.each do |number|
      PhoneNumber.new.wont have_valid(:number).when(number)
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
