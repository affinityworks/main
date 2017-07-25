require 'test_helper'

class FacebookPagesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @facebook_page = facebook_pages(:one)
  end

  test "should get index" do
    get facebook_pages_url
    assert_response :success
  end

  test "should get new" do
    get new_facebook_page_url
    assert_response :success
  end

  test "should create facebook_page" do
    assert_difference('FacebookPage.count') do
      post facebook_pages_url, params: { facebook_page: {  } }
    end

    assert_redirected_to facebook_page_url(FacebookPage.last)
  end

  test "should show facebook_page" do
    get facebook_page_url(@facebook_page)
    assert_response :success
  end

  test "should get edit" do
    get edit_facebook_page_url(@facebook_page)
    assert_response :success
  end

  test "should update facebook_page" do
    patch facebook_page_url(@facebook_page), params: { facebook_page: {  } }
    assert_redirected_to facebook_page_url(@facebook_page)
  end

  test "should destroy facebook_page" do
    assert_difference('FacebookPage.count', -1) do
      delete facebook_page_url(@facebook_page)
    end

    assert_redirected_to facebook_pages_url
  end
end
