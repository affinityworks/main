require 'test_helper'

class Api::V1::PeopleControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test '#index' do
    Api::User.create!(osdi_api_token: 'CF32zTyg_KXFQbPzvoz3', name: 'API friend', email: 'api@example.com')

    get api_v1_people_url, headers: { 'OSDI-API-Token': 'CF32zTyg_KXFQbPzvoz3' }, as: :json
    assert_response :success
    assert 'application/json', response.header['Content-Type']

    json = JSON.parse(response.body)
    pp json
    assert json['_embedded'].present?

    people = json['_embedded']['osdi:people']
    assert_equal 2, people.size

    assert people.all? { |p| p['identifiers'].size == 1 }, 'Each person should have an identifier'
    assert people.all? { |p| p['created_date'].present? }, 'Each person should have created_date'
    assert people.all? { |p| p['modified_date'].present? }, 'Each person should have modified_date'

    person = people.find { |p| p['id'] == 1 }
    assert_equal ['White', 'Hispanic'], person['ethnicities'], 'ethnicities'
  end

  test 'pagination' do
    # 2 fixtures + 6 new people = 8 in DB
    6.times do |i|
      Person.create!(email: "person_#{i}@example.com", password: 'topsecret')
    end

    Api::User.create!(osdi_api_token: 'CF32zTyg_KXFQbPzvoz3', name: 'API friend', email: 'api@example.com')

    get api_v1_people_url,
        headers: { 'OSDI-API-Token': 'CF32zTyg_KXFQbPzvoz3' },
        params: { per_page: 3, page: 2 },
        as: :json

    assert_response :success

    json = JSON.parse(response.body)
    people = json['_embedded']['osdi:people']
    assert_equal 3, people.size

    assert_equal 3, json['total_pages'], 'total_pages'
    assert_equal 8, json['total_records'], 'total_records'
    assert_equal 2, json['page'], 'page'

    links = json['_links']
    assert_equal 'http://www.example.com/api/v1/people', links['self']['href'], 'self link'
    assert_equal '/api/v1/people?page=1', links['previous']['href'], 'previous link'
    assert_equal '/api/v1/people?page=3', links['next']['href'], 'next link'
  end

  test 'require API token' do
    get api_v1_people_url as: :json
    assert_response 401
  end

  test 'support auth token as query parm' do
    Api::User.create!(osdi_api_token: 'CF32zTyg_KXFQbPzvoz3', name: 'API friend', email: 'api@example.com')

    get api_v1_people_url, params: { osdi_api_token: 'CF32zTyg_KXFQbPzvoz3' }, as: :json
    assert_response :success
  end
end
