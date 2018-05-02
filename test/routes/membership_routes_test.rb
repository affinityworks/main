require_relative "../test_helper"

class MembershipRoutesTest < ActionDispatch::IntegrationTest
  specify do
    assert_routing(
      { path: "/groups/1/memberships", method: :post },
      { controller: "memberships", action: "create", group_id: "1" }
    )
  end
end
