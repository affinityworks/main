require 'test_helper'

class Api::Resources::EmailAddressRepresenterTest < ActiveSupport::TestCase
  test 'to_json' do
    email = EmailAddress.new(
      address: 'sock.puppet@example.com',
      primary: false
    )

    json = JSON.parse(Api::Resources::EmailAddressRepresenter.new(email).to_json)

    assert_equal 'sock.puppet@example.com', json['address'], 'address'
    assert_equal false, json['primary'], 'primary'
  end

  test '#from_json' do
    email_address = EmailAddress.new
    Api::Resources::EmailAddressRepresenter.new(email_address).from_json(
      '{
          "primary": true,
          "address": "johnsmith@mail.com",
          "address_type": "Personal",
          "status": "subscribed"
      }'
    )
    assert_equal 'johnsmith@mail.com', email_address.address, 'address'
    assert_equal 'Personal', email_address.address_type, 'address_type'
    assert_equal 'subscribed', email_address.status, 'status'
    assert email_address.primary?, 'primary?'
  end
end
