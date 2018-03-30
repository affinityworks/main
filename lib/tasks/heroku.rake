namespace :heroku do
  task postdeploy: :environment do

    Rake::Task["db:schema:load"].execute
    Rake::Task["db:seed"].execute

    if ENV['HEROKU_APP_NAME']&.include? "dev"
      `heroku config:set HOSTNAME=${HEROKU_APP_NAME}.herokuapp.com -a ${HEROKU_APP_NAME}`
    end
  end
end
