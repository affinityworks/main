

require 'test_helper'

class AuthenticationTest < ActionDispatch::IntegrationTest

  test "redirects group member to their groups page on login" do
    get "/events/"
    assert_response :redirect
    follow_redirect!

    post "/admin/login",
      params: {"utf8"=>"✓", "person"=>{"email"=>"joe@somewhere.com", "password"=>"password", "remember_me"=>"0"}, "commit"=>"Login"}
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert path == '/groups/1'
  end

  test "redirects group organizer to their events on login" do
    get "/events/"
    assert_response :redirect
    follow_redirect!

    post "/admin/login",
      params: {"utf8"=>"✓", "person"=>{"email"=>"jane@elsewehre.com", "password"=>"password", "remember_me"=>"0"}, "commit"=>"Login"}
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert members_path == path
  end

end
