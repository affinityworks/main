class FeatureToggle < ApplicationRecord
  belongs_to :group, optional: true

  FEATURES = %i[email_google_group]

  def on?(feature)
    return false unless FEATURES.include? feature
    send feature
  end
end
