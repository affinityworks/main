module HasFeatureToggles
  extend ActiveSupport::Concern

  included do
    has_one :feature_toggle

    alias_method :feature_toggles, :feature_toggle

    def feature_on?(feature)
      feature_toggle&.on?(feature) || false
    end

    def toggle_feature_on(feature)
      toggle(feature, true)
    end

    def toggle_feature_off(feature)
      toggle(feature, false)
    end

    private
    
    def toggle(feature, new_val)
      toggle = feature_toggle || create_feature_toggle
      toggle.update(feature => new_val)
      self
    end


  end
end