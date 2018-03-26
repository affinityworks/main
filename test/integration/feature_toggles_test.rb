require_relative '../test_helper'

class FeatureTogglesTest < ActionDispatch::IntegrationTest
  describe ".index api calls" do
    describe "for group in swing left network" do
      it "reports events are off"
      it "reports google groups are on"
    end
    describe "for organizer of group without toggles" do
      it "reports events are on"
      it "reports google groups are off"
    end
  end
end
