FactoryBot.define do
  factory :email_address do
    sequence :address do |n| 
    	Faker::Internet.email.gsub("@", "#{n}@")
    end
    primary true
  end
end
