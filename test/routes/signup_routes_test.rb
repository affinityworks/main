require_relative "../test_helper"

class SubgroupRoutesTest < ActionDispatch::IntegrationTest
  it "has a subgroups#new route" do
    assert_routing(
      { path: "/groups/1/subgroups/new", method: :get },
      { controller: "subgroups", action: "new", group_id: "1" }
    )
  end

  it "has a subgroups#create route" do
    assert_routing(
      { path: "/groups/1/subgroups", method: :post },
      { controller: "subgroups", action: "create", group_id: "1" }
    )
  end

  it "has a subgroups#signup route" do
    assert_routing(
      { path: "/groups/1/subgroups/signup", method: :post },
      { controller: "subgroups", action: "signup", group_id: "1" }
    )
  end
end
