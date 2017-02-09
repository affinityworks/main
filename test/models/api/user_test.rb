require 'test_helper'

class Api::UserTest < ActiveSupport::TestCase
  test 'valid creation' do
    Api::User.create!(osdi_api_token: 'secret1337', email: 'api@example.com', name: 'API User')
  end
end
