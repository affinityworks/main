require 'test_helper'

class Api::V1::PeopleControllerTest < ActionDispatch::IntegrationTest
  test "#index" do
    get api_v1_people_url as: :json
    assert_response :success
  end
end
