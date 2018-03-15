require_relative "../test_helper"

class FeatureToggleTest < ActiveSupport::TestCase

  let(:swing_left){ groups(:swing_left) }

  it "enables a feature that has no rules" do
    FeatureToggle.active?(:foobar).
      must_equal true
  end

  it "enables a feature for group that has not been black-listed" do
    FeatureToggle.active?(:events, group: groups(:one)).
      must_equal true
  end

  it "disables a feature for a black-listed group" do
    FeatureToggle.active?(:events, group: swing_left).
      must_equal false
  end

  # Hmmm....
  it "disables a feature for all subgroups of a black-listed group"
end
