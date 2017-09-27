require 'test_helper'

class ProfileControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers


  test 'get #groups' do
    person = people(:organizer)
    sign_in person

    get groups_profile_index_url, as: :json
    json = JSON.parse(response.body)
    assert_response :success

    assert_equal JsonApi::GroupsRepresenter.for_collection.new(person.groups).as_json, json['groups']
    assert_not_equal Group.count, json['groups']['data'].count
  end


  test 'get #profile' do
    person = people(:organizer)
    sign_in person

    get profile_index_url
    assert_response :success
  end


end
