Whacamole.configure("affinityworks") do |config|
  config.api_token = ENV['HEROKU_API_TOKEN']
  config.dynos = %w{web}
  config.restart_threshold = 1000 # MB
  config.restart_window = 30*60 # SECONDS
end

Whacamole.configure("production-swingleft") do |config|
  config.api_token = ENV['HEROKU_API_TOKEN']
  config.dynos = %w{web}
  config.restart_threshold = 500 # MB
  config.restart_window = 30*60 # SECONDS
end