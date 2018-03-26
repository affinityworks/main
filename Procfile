release: bundle exec rake db:migrate
web: bundle exec puma -C config/puma.rb
worker: bundle exec rake resque:work QUEUE='*'
