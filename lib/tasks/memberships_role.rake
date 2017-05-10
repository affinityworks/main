namespace :memberships_role do
  task setup: :environment do
    Membership.find_in_batches do |batch|
      batch.each do |membership|
        membership.role == 'admin' ? membership.organizer! : membership.member!
      end
    end
  end
end
