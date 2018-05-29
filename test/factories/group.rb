FactoryBot.define do
  factory :group do
    name Faker::Hipster.sentence(3)
  end

  factory :subgroup, class: Group do
    name Faker::Hipster.sentence(3)
    affiliated_with {[ FactoryBot.create(:group) ]}
  end

  factory :subgroup_with_members, parent: :subgroup do
    transient do
      member_count 1
    end

    after :create do |group, evaluator|
      evaluator.member_count.times do
        FactoryBot.create(
          :membership,
          person: FactoryBot.create(:person_with_contact_info),
          group: group
        )
      end
    end
  end
end
