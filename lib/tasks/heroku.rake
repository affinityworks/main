require 'yaml'

namespace :heroku do
  task release: :environment do
    Rake::Task["db:migrate"]
    Migration.update_networks
  end

  task postdeploy: :environment do
    if ENV["HEROKU_APP_NAME"]&.include? "dev"
      logger = Logger.new(STDOUT)

      # this will sync from ActionNetwork (sloooow!), avoid it if we can
      if false #Membership.count == 0
        logger.info("seeding database...")
        Rake::Task["db:schema:load"].execute
        Rake::Task["db:seed"].execute
      end
    end
  end

  task export_vars: :environment do
    puts "***************************WARNING*****************************"
    puts "  IF YOU HAVE LOCAL ENV VARS THAT CONFLICT WITH HEROKU VALUES,"
    puts "      RUNNING THIS SCRIPT WILL OVERWRITE THE HEROKU VALUES"
    puts "           ARE YOU SURE YOU WANT TO CONTINUE? (y/n)"
    puts "***************************************************************"

    answer = STDIN.gets.chomp
    exit unless answer == 'y' || answer == 'yes'

    puts "--- decrypting config files"
    sh "./bin/blackbox_decrypt_all_files"

    puts "--- Checking for heroku-config plugin"
    plugins = `heroku plugins`

    if plugins.include? "heroku-config"
      puts "heroku-config plugin already installed!"
    else
      puts "Installing heroku-config plugin..."
      sh "heroku plugins:install heroku-config"
    end

    puts "--- BEGIN exporting heroku config vars"
    heroku_dir = ".env.heroku"

    heroku_apps = YAML.load_file("config/heroku.yml")["apps"]

    heroku_apps.each do |filename, app_name|

      puts "--- exporting vars for #{app_name}"

      sh "heroku config:push -o -f #{heroku_dir}/#{filename} -a #{app_name}"

      puts "\n"
    end

    puts "--- DONE exporting config vars"
  end

  task ci: :environment do
    sh "cd client && bundle exec rake react_on_rails:locale && yarn run build:production"
  end
end
