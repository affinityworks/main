require_relative "../../test_helper"

class HasFeatureTogglesText < ActiveSupport::TestCase
  before do
    @group = FactoryBot.create(:group)
    @group_2 = FactoryBot.create(:group)

    @toggle_set = FactoryBot.create(
      :feature_toggle,
      email_google_group: true,
      group: @group
    )

    @toggle_set_2 = FactoryBot.create(
      :feature_toggle,
      email_google_group: false,
      group: @group_2
    )
  end

  describe "associations" do
    specify { @group.feature_toggle.must_equal @toggle_set }
    specify { @group.feature_toggles.must_equal @toggle_set }
  end

  describe "instance methods" do
    describe "#feature_on?" do
      it "reports when a feature is toggled on" do
        @group.feature_on?(:email_google_group).must_equal true
      end

      it "reports when a feature is toggled off" do
        @group_2.feature_on?(:email_google_group).must_equal false
      end

      it "reports an unspecified feature as off" do
        Group.new.feature_on?(:email_google_group).must_equal false
      end 
    end

    describe "#toggle_feature_on" do
      it "toggles an off feature to on" do
        @group_2.toggle_feature_on(:email_google_group)
        @group_2.feature_on?(:email_google_group).must_equal true
      end

      it "toggles an unspecified feature to on" do
        FactoryBot
          .create(:group)
          .toggle_feature_on(:email_google_group)
          .feature_on?(:email_google_group)
          .must_equal true
      end
    end

    describe "#toggle_feature_off" do
      it "toggles an on feature to off" do
        @group.toggle_feature_off(:email_google_group)
        @group.feature_on?(:email_google_group).must_equal false
      end

      it "toggles an unspecified feature to off" do
        FactoryBot
          .create(:group)
          .toggle_feature_off(:email_google_group)
          .feature_on?(:email_google_group)
          .must_equal false
      end
    end
  end
end
