require 'test_helper'

class TestController < ApplicationController
  before_action :authenticate_person!, only: :index

  def show
    @current_role = current_role
    head :ok
  end

  def index
    @current_role = current_role
    head :ok
  end

end

class ApplicationControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers



  setup do
    Rails.application.routes.draw do
      controller :test do
        get '/test', to: 'test#index'
        get '/test/:id', to: 'test#show'
      end
    end
    @controller = TestController.new
  end

  teardown do
    Rails.application.reload_routes!
  end

  test 'current_role, without current user and current_group' do
    get '/test/1'
    assert_equal assigns(:current_role), ''
  end


  def set_role_and_sign_in(person, group)
    sign_in person
    get test_url(group_id: group.id)
  end

  test 'current_role, if person is member should return the role' do
    membership = memberships(:one)
    set_role_and_sign_in(membership.person, membership.group)
    assert_equal assigns(:current_role), 'member'

    membership.update(role: 1)

    set_role_and_sign_in(membership.person, membership.group)
    assert_equal assigns(:current_role), 'organizer'

    membership.update(role: 2)

    set_role_and_sign_in(membership.person, membership.group)
    assert_equal assigns(:current_role), 'volunteer'
  end

  test 'current_role, if person is not member in a group should return member' do

    membership = memberships(:two)
    set_role_and_sign_in(membership.person, groups(:one))

    assert_equal assigns(:current_role), 'member'
  end

  test 'current_role, if person is volunteer in affliate group' do

    membership = memberships(:forth)
    membership.update(role: 2)

    set_role_and_sign_in(membership.person, groups(:test))

    assert_equal assigns(:current_role), 'volunteer'
  end






end
