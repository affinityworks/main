Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = true

  # Show full error reports.
  config.consider_all_requests_local = true

  # Enable/disable caching. By default caching is disabled.
  if Rails.root.join('tmp/caching-dev.txt').exist?
    config.action_controller.perform_caching = true

    config.cache_store = :memory_store
    config.public_file_server.headers = {
      'Cache-Control' => 'public, max-age=172800'
    }
  else
    config.action_controller.perform_caching = false

    config.cache_store = :null_store
  end


  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  # Suppress logger output for asset requests.
  config.assets.quiet = true

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true

  # Use an evented file watcher to asynchronously detect changes in source code,
  # routes, locales, etc. This feature depends on the listen gem.
  config.file_watcher = ActiveSupport::EventedFileUpdateChecker

  # TODO: (aguestuser|01-Mar-2018)

  # URGENT:
  # for URLs to make sense, we MUST provide different hostnames for:
  # 1. swingleft prod v. affinityworks prod (w/ fixed hostnames known in advance)
  # 2. arbitrary review apps (w/ arbitrary hostnames generated at deploy time)
  # hard problem! potential solution:
  # consider using ENV['HEROKU_URL'] for prod, which requires:
  # `heroku config:set HEROKU_URL=$(heroku info -s | grep web-url | cut -d= -f2)`
  # as per: http://www.chrisjmendez.com/2016/12/19/how-to-get-your-web-url-from-heroku-dynamically/

  # NOT URGENT:
  # perhaps we could DRY this up by putting it in application.rb
  # and making env-dependent vars like host vary according to env
  # in a yml file such as `config/network.yml`?
  # (see `ethereum.yml` in test-www-metamask for an example)

  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.perform_caching = false
  config.action_mailer.perform_deliveries = true
  config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    :port           => ENV['MAILGUN_SMTP_PORT'],
    :address        => ENV['MAILGUN_SMTP_SERVER'],
    :user_name      => ENV['MAILGUN_SMTP_LOGIN'],
    :password       => ENV['MAILGUN_SMTP_PASSWORD'],
    :domain         => ENV['MAILGUN_DOMAIN'],
    :authentication => :plain,
    :ssl            => true
  }
end
