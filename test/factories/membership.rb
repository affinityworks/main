FactoryBot.define do
  factory :membership do
    group
    person
    role %w[member organizer].sample

    trait :with_contact_info do
      person { FactoryBot.create(:person_with_contact_info) }
    end

    factory :membership_with_tags do
      after :create do |membership|
        tags = 3.times.map { FactoryBot.build(:tag).name }
        membership.tag_list.add(tags)
        membership.save
      end
    end
  end
end
