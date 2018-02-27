require 'test_helper'

class SubgroupsControllerTest < ActionController::TestCase

  test "routes" do
    assert_routing(
      { path: "/groups/1/subgroups/new", method: :get },
      { controller: "subgroups", action: "new", group_id: "1" }
    )
  end
end
