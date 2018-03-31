namespace :config do
  task update_networks: :environment do
    puts "updating networks..."
    Migration.update_networks unless ENV["RAILS_ENV"] == 'test'
    puts "...updated networks"
  end
end
