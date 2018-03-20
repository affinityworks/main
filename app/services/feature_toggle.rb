class FeatureToggle

  RULES = {
    events: {
      disable_for: {
        groups: Set.new(["Swing Left"])
      }
    }
  }.freeze

  class << self
    # (symbol, symbol) => boolean
    def active?(feature, group: nil)
      !disable_for_group?(feature, group)
    end
  end

  private

  class << self
    def disable_for_group?(feature, group)
      RULES.dig(feature, :disable_for, :groups)&.include?(group.name) if group
    end
  end
end
