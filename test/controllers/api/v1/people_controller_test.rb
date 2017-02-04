require 'test_helper'

class Api::V1::PeopleControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test '#index' do
    Api::User.create!(osdi_api_token: 'CF32zTyg_KXFQbPzvoz3', name: 'API friend', email: 'api@example.com')

    get api_v1_people_url, headers: { 'OSDI-API-Token': 'CF32zTyg_KXFQbPzvoz3' }, as: :json
    assert_response :success

    json = JSON.parse(response.body)
    assert json['_embedded'].present?

    people = json['_embedded']['osdi:people']
    assert_equal people.size, 2

    assert people.all? { |p| p['identifiers'].size == 1 }, 'Each person should have an identifier'
    assert people.all? { |p| p['created_date'].present? }, 'Each person should have created_date'
    assert people.all? { |p| p['modified_date'].present? }, 'Each person should have modified_date'
  end

  test 'pagination' do

  end

  test 'require API token' do
    get api_v1_people_url as: :json
    assert_response 401
  end
end
