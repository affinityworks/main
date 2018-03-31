namespace :heroku do
  task postdeploy: :environment do
    if ENV["HEROKU_APP_NAME"]&.include? "dev"
      logger = Logger.new(STDOUT)

      # this will sync from ActionNetwork (sloooow!), avoid it if we can
      if Membership.count == 0
        logger.info("seeding database...")
        Rake::Task["db:schema:load"].execute
        Rake::Task["db:seed"].execute
      end
    end
  end
end
