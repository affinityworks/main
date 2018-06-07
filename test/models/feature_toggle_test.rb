require_relative '../test_helper'

class FeatureToggleTest < ActiveSupport::TestCase

  let(:feature_toggle) { FactoryBot.create(:feature_toggle) }

  describe "associations" do
    specify { feature_toggle.group.must_be_instance_of Group } 
  end


  describe '#on?' do

    FeatureToggle::FEATURES.each do |feature|
      it "checks if #{feature} is on" do
        FactoryBot.build(:feature_toggle, feature => true)
          .on?(feature).must_equal true
      end
    end
        
    it 'handles non-existent features' do
      feature_toggle.on?(:non_existent).must_equal false      
    end
  end
end
