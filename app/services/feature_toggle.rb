class FeatureToggle

  RULES = {
    events: {
      disable_for: {
        groups: Set.new(
          "Swing Left"
        )
      }
    }
  }.freeze

  class << self
    # (symbol, symbol) => boolean
    def active?(feature, group: nil)
      active_for_group?(feature, group)
    end
  end

  private

  class << self
    def active_for_group?(feature, group)
      !group ||
        !RULES.dig(:events, :disable_for, :groups)&.include?(group.name)
    end
  end
end
