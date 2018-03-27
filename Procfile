release: bundle exec rake db:migrate
web: bundle exec puma -C config/puma.rb
worker: bundle exec rake jobs:work

# comment: consider bin/rails server -p $PORT -e $RAILS_ENV for web (old heroku default)
