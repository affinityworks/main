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

  test 'should update person identifier when primary email changes' do
    person = people(:one)
    email_address = EmailAddress.create(primary: true, person: person, address: 'example@example.com')
    hashed_address = Digest::SHA256.base64digest email_address.address
    assert_equal hashed_address, person.identifier_id('affinity_id')
  end
end
