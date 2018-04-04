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

  task export_vars: :environment do
    puts "--- BEGIN exporting config vars"
    export_path = "lib/export/heroku"

    Dir.
      entries(export_path).
      select{ |f| f != "." && f != ".." }.
      each do |app_name|

      puts "--- exporting vars for #{app_name}"
      File.readlines("#{export_path}/#{app_name}").each do |var_assignment|
        cmd = "heroku config:set #{var_assignment.sub("\n", "")} -a #{app_name}"
        %x(#{cmd})
      end

      puts "--- deleting files for #{app_name}"
      FileUtils.rm("#{export_path}/#{app_name}")
    end

    puts "--- DONE exporting config vars"
  end
end
