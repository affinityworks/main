require_relative "../test_helper"

class StaticFeatureTogglesControllerTest < ActionController::TestCase
  test "routes" do
    assert_routing(
      { path: '/static_feature_toggles', method: :get },
      { controller: 'static_feature_toggles', action: 'index' }
    )
  end
end
