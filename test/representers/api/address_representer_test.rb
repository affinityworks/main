require 'test_helper'

class Api::AddressRepresenterTest < ActiveSupport::TestCase
  test 'to_json' do
    address = Address.new(
      latitude: 45.15,
      longitude: 120,
      postal_code: '13035'
    )

    json = JSON.parse(Api::AddressRepresenter.new(address).to_json)

    assert_equal '13035', json['postal_code'], 'postal_code'
    assert_equal 45.15, json['location']['latitude'], 'location.latitude'
    assert_equal 120, json['location']['longitude'], 'location.longitude'
  end
end
