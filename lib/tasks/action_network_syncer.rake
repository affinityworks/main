namespace :action_network_syncer do
  task sync_groups: :environment do
    Rails.logger = Logger.new(STDOUT)
    Group.find_in_batches do |batch|
      batch.each(&:sync_with_action_network)
    end
    Rails.logger.debug '### IMPORT FINISHED ###'
  end

  task export: :environment do
    Rails.logger = Logger.new(STDOUT)
    Rails.logger.debug '### EXPORT STARTED ###'
    Group.find_in_batches do |batch|
      batch.each do |group|
        Rails.logger.debug "### EXPORTING #{group.name} MEMBERS ###"
        group.members.unsynced.each { |member| member.export(group) }
        Rails.logger.debug "### EXPORTING #{group.name} ATTENDANCES ###"
        group.attendances.unsynced.each { |attendance| attendance.export(group) }
      end
    end
    Rails.logger.debug '### EXPORT FINISHED ###'
  end
end



namespace :action_network do
  task import: :environment do
    Rake::Task["action_network_syncer:sync_groups"].execute
  end

  task sync: :environment do
    Rake::Task["action_network_syncer:sync_groups"].execute
  end

  task export: :environment do
    Rake::Task["action_network_syncer:export"].execute
  end
end
