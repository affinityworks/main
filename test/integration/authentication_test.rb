

require 'test_helper'

class AuthenticationTest < ActionDispatch::IntegrationTest

  test "redirects group member to their profile page on login" do
    get "/profile/"
    assert_response :redirect
    follow_redirect!

    post "/admin/login",
      params: {"utf8"=>"✓", "person"=>{"email"=>"joe@somewhere.com", "password"=>"password", "remember_me"=>"0"}, "commit"=>"Login"}
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert path == profile_index_path
  end

  test "redirects group organizer to their profile on login" do
    get "/profile/"
    assert_response :redirect
    follow_redirect!

    post "/admin/login",
      params: {"utf8"=>"✓", "person"=>{"email"=>"jane@elsewehre.com", "password"=>"password", "remember_me"=>"0"}, "commit"=>"Login"}
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert profile_index_path == path
  end

end
