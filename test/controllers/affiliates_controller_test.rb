require 'test_helper'

class AffiliatesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test 'get #index' do
    person = people(:organizer)
    group = person.groups.first
    sign_in person

    affiliate = Group.new(an_api_key: rand(1_000_000))
    Affiliation.create(group: group, affiliated: affiliate)

    get group_affiliates_url(group.id), as: :json

    assert_response :success
  end
end
