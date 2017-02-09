require 'test_helper'

class Api::EmailAddressRepresenterTest < ActiveSupport::TestCase
  test 'to_json' do
    email = EmailAddress.new(
        address: 'sock.puppet@example.com',
        primary: false
      )

    json = JSON.parse(Api::EmailAddressRepresenter.new(email).to_json)

    assert_equal 'sock.puppet@example.com', json['address'], 'address'
    assert_equal false, json['primary'], 'primary'
  end
end
