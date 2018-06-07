namespace :feature_toggles do
  task :create, [:toggle_name] do |_, args|
    toggle = args[:toggle_name]
    raise "USAGE: Toggles must be strings" if toggle.include?(":")

    puts "Creating and running #{toggle} toggle migration..."

    sh "rails g migration Add#{toggle.camelize}ToFeatureToggle #{toggle}:boolean"
    
    sh "rake db:migrate"

    puts "Success!\n\n"

    puts "Likely next steps:"
    puts "$ git add ."
    puts "$ git commit -m 'Add #{toggle} to FeatureToggle model.'"
    puts "$ git push\n\n"
  end
end