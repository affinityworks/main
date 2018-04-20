require 'test_helper'

class JoinControllerTest < ActionController::TestCase
  test "routes" do
    assert_routing(
      { path: "/groups/1/join", method: :get },
      { controller: "groups", action: "join", group_id: "1" }
    )
  end
end
