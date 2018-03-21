class FeatureToggle

  # TODO (aguestuser|21 Mar 2018)
  # eventually read these from Rails.configuration.networks
  NETWORKS = HashWithIndifferentAccess.new(
    swing_left: { name: 'Swing Left Network' }
  ).freeze

  RULES = {
    events: {
      disable_for: {
        networks: Set.new([
          NETWORKS.dig(:swing_left, :name)
        ])
      }
    },
    google_groups: {
      enable_for: {
        networks: Set.new([
          NETWORKS.dig(:swing_left, :name)
        ])
      }
    }
  }.freeze

  class << self
    # (symbol, symbol) => boolean
    def on?(feature, group = nil)
      return enable_for_group?(feature, group) if is_opt_in?(feature)
      return !disable_for_group?(feature, group) if is_opt_out?(feature)
      true
    end
  end

  private

  class << self

    def is_opt_in?(feature)
      RULES.dig(feature, :enable_for)
    end

    def is_opt_out?(feature)
      RULES.dig(feature, :disable_for)
    end

    def enable_for_group?(feature, group)
      apply_rule(feature, :enable_for, group&.primary_network)
    end

    def disable_for_group?(feature, group)
      apply_rule(feature, :disable_for, group&.primary_network)
    end

    def apply_rule(feature, rule, network)
      RULES.dig(feature, rule, :networks)&.include?(network&.name) || false
    end
  end
end
