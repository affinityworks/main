FactoryBot.define do
  factory :membership do
    group
    person
    role %w[member organizer].sample

    trait :with_contact_info do
      person { FactoryBot.create(:person_with_contact_info) }
    end
  end
end
