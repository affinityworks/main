require 'test_helper'
require 'minitest/mock'

class Api::V1::PeopleControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers

  test '#index' do
    sign_in people(:one)
    token = Minitest::Mock.new
    token.expect(:acceptable?, true, [Doorkeeper::OAuth::Scopes])

    @controller.stub(:doorkeeper_token, token) do
      get :index, format: :json
      assert_response :success
      assert 'application/json', response.header['Content-Type']

      json = JSON.parse(response.body)
      assert json['_embedded'].present?

      people = json['_embedded']['osdi:people']
      assert_equal 8, people.size

      assert people.all? { |p| p['identifiers'].size >= 1 }, 'Each person should have an identifier'
      assert people.all? { |p| p['created_date'].present? }, 'Each person should have created_date'
      assert people.all? { |p| p['modified_date'].present? }, 'Each person should have modified_date'

      person = people.find { |p| p['identifiers'].first == 'advocacycommons:1' }
      assert_equal ['White', 'Hispanic'], person['ethnicities'], 'ethnicities'
    end
  end

  test 'pagination' do
    sign_in people(:one)
    token = Minitest::Mock.new
    token.expect(:acceptable?, true, [Doorkeeper::OAuth::Scopes])

    6.times do |i|
      Person.create!(password: 'topsecret', given_name: 'given_name', family_name: 'family_name')
    end

    @controller.stub(:doorkeeper_token, token) do
      get :index, params: { per_page: 3, page: 2 }, format: :json

      assert_response :success

      json = JSON.parse(response.body)
      people = json['_embedded']['osdi:people']
      assert_equal 3, people.size

      assert_equal 5, json['total_pages'], 'total_pages'
      assert_equal 14, json['total_records'], 'total_records'
      assert_equal 2, json['page'], 'page'

      links = json['_links']
      assert_equal 'http://test.host/api/v1/people', links['self']['href'], 'self link'
      assert_equal '/api/v1/people?page=1', links['previous']['href'], 'previous link'
      assert_equal '/api/v1/people?page=3', links['next']['href'], 'next link'
    end
  end

  test 'require API token' do
    get :index, format: :json
    assert_response 401
  end
end
