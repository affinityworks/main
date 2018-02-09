require 'test_helper'

class SignupsControllerTest < ActionController::TestCase

  test "routes" do

    assert_routing(
      { path: "/groups/1/signup_forms/1/signups/new", method: :get },
      { controller: "signups", action: "new", group_id: "1", signup_form_id: "1" }
    )

    assert_routing(
      { path: "/groups/1/signup_forms/1/signups", method: :post },
      { controller: 'signups', action: 'create', group_id: '1', signup_form_id: '1'}
    )
  end
end
