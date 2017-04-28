namespace :action_network_syncer do
  task sync_groups: :environment do
    Rails.logger = Logger.new(STDOUT)
    Group.find_in_batches do |batch|
      batch.each(&:sync_with_action_network)
    end
    Rails.logger.debug '### IMPORT FINISHED ###'
  end
end
