FactoryBot.define do
  factory :personal_address do
    postal_code Faker::Address.zip_code
    primary true
  end
end
