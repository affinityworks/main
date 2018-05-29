FactoryBot.define do
  factory :personal_address do
    postal_code Faker::Address.zip_code
  end
end
