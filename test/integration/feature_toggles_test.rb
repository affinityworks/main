require_relative '../test_helper'

class FeatureTogglesTest < ActionDispatch::IntegrationTest

  describe ".index api calls" do
    def toggle_for(feature, group_id)
      get '/feature_toggles', params: { feature: feature, group_id: group_id }
      JSON.parse(response.body).fetch(feature)
    end

    describe "for primary members of national network" do
      let(:group_id){ groups(:ohio_chapter).id }

      it "reports events are off" do
        toggle_for('events', group_id).must_equal false
      end

      it "reports google groups are on" do
        toggle_for('google_groups', group_id).must_equal true
      end
    end

    describe "for group without any toggles set" do
      let(:group_id){ groups(:fantastic_four).id }

      it "reports events are on" do
        toggle_for('events', group_id).must_equal true
      end

      it "reports google groups are off" do
        toggle_for('google_groups', group_id).must_equal false
      end
    end
  end
end
