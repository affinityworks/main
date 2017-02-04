require 'test_helper'

class Api::V1::EntryPointControllerTest < ActionDispatch::IntegrationTest
  test "#show" do
    get api_v1_url as: :json
    assert_response :success
  end
end
