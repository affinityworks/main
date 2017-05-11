require 'test_helper'

class Admin::SessionsController < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test 'is not found when the user is not admin' do
    sign_in people(:one)
    get admin_groups_url
    assert_response :not_found
  end

  test 'is successful when the user is admin' do
    person = people(:one)
    person.admin = true
    person.save
    sign_in(person)

    get admin_groups_url
    assert_response :success
  end
end
