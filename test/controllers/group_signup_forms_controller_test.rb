require 'test_helper'

class GroupSignupFormsControllerTest < ActionController::TestCase

  test "routes" do
    assert_routing "/groups/1/signup_forms/1",
                   controller: "group_signup_forms",
                   action:     "show",
                   group_id:   "1",
                   id:         "1"
  end
end
