require 'resque/tasks'
task "resque:setup" => :environment do
  ENV['QUEUE'] ||= '*'
  ENV['QUEUE'] = '*'
  ENV['TERM_CHILD'] = '1'
  ENV['RESQUE_TERM_TIMEOUT'] = '10'
  #for redistogo on heroku http://stackoverflow.com/questions/2611747/rails-resque-workers-fail-with-pgerror-server-closed-the-connection-unexpectedl
  Resque.before_fork do
    defined?(ActiveRecord::Base) and
      ActiveRecord::Base.connection.disconnect!
  end

  Resque.after_fork do
    defined?(ActiveRecord::Base) and
      ActiveRecord::Base.establish_connection
  end

end

desc "Alias for resque:work (To run workers on Heroku)"
task "jobs:work" => "resque:work"