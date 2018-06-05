require_relative "../test_helper"

class StaticFeatureTogglesControllerTest < ActionController::TestCase
  test "routes" do
    assert_routing(
      { path: '/feature_toggles', method: :get },
      { controller: 'feature_toggles', action: 'index' }
    )
  end
end
