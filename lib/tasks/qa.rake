namespace :qa do
  MEMBER_COUNT = 2000

  task count: :environment do
    counts = {
      groups: Group.count,
      people: Person.count,
      affilitations: Affiliation.count,
      memberships: Membership.count
    }
    puts "#{counts}"
  end

  task gen_big_subgroup: :environment do
    puts "Starting gen big subgroup...."
    g = Group.find_by_name("National Network")
    sg = FactoryBot.create(:subgroup_with_members,
                           affiliated_with: [g],
                           member_count: MEMBER_COUNT)
    puts "DONE! #{MEMBER_COUNT}-member subgroup created with id #{sg.id}."
  end

  task remove_big_subgroup: :environment do
    puts "deleting last group..."
    Group.last.destroy
    puts "deleting #{MEMBER_COUNT} members..."
    Person.last(MEMBER_COUNT).map(&:destroy)
    puts "DONE!"
  end
end
