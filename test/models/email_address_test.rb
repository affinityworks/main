require 'test_helper'

class EmailAddressTest < ActiveSupport::TestCase
  test 'basic associations' do
    one = email_addresses(:one)
    assert one.person
  end

  test 'should not save email with no data' do
    address = EmailAddress.new
    assert_not address.save
  end
end
