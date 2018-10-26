require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module AdvocacyCommons
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.eager_load_paths << Rails.root.join('app', 'graph', 'types')
    config.eager_load_paths << Rails.root.join('app', 'graph', 'fields')
    config.eager_load_paths << Rails.root.join('app', 'presenters')

    config.eager_load_paths << Rails.root.join('lib')

    config.active_job.queue_adapter = :resque

    # custom config yml
    config.networks = config_for(:networks)
    config.feature_toggles = config_for(:feature_toggles)

    config.active_record.belongs_to_required_by_default = false
  end
end
