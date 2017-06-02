

require 'test_helper'

class AuthenticationTest < ActionDispatch::IntegrationTest

  #FIXME: these tests randomly fail
  #ArgumentError: A copy of ApplicationController has been removed from the module tree but is still active!
  
  # test "redirects group member to their groups page on login" do
  #   get group_events_url(1)
  #   assert_response :redirect
  #   follow_redirect!
  #
  #   post "/admin/login",
  #     params: {"utf8"=>"✓", "person"=>{"email"=>"joe@somewhere.com", "password"=>"password", "remember_me"=>"0"}, "commit"=>"Login"}
  #   assert_response :redirect
  #   follow_redirect!
  #   assert_response :success
  #   assert path == '/groups/1'
  # end
  #
  # test "redirects group organizer to their events on login" do
  #   get group_events_url(1)
  #   assert_response :redirect
  #   follow_redirect!
  #
  #   post "/admin/login",
  #     params: {"utf8"=>"✓", "person"=>{"email"=>"jane@elsewehre.com", "password"=>"password", "remember_me"=>"0"}, "commit"=>"Login"}
  #   assert_response :redirect
  #   follow_redirect!
  #   assert_response :success
  #   assert group_members_path(1) == path
  # end

end
