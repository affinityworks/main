FactoryBot.define do
  factory :person do
    sequence(:given_name) { Faker::Name.first_name }
    sequence(:family_name) { Faker::Name.last_name }

    trait :with_email do
      email_addresses { [FactoryBot.create(:email_address)] }
    end

    trait :with_personal_address do
      personal_addresses { [FactoryBot.create(:personal_address)] }
    end

    trait :with_phone_number do
      phone_numbers { [FactoryBot.create(:phone_number)] }
    end

    factory :person_with_contact_info do
      after :create do |p|
        p.email_addresses << FactoryBot.create(:email_address)
        p.personal_addresses << FactoryBot.create(:personal_address)
        p.phone_numbers << FactoryBot.create(:phone_number)
      end
    end
  end
end
