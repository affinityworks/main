require 'test_helper'

class SignupFormsControllerTest < ActionController::TestCase

  test "routes" do
    assert_routing(
      { path: "/groups/1/signup_forms/1", method: :get },
      { controller: "signup_forms", action: "show", group_id: "1", id: "1" }
    )
  end
end
