FactoryBot.define do
  factory :phone_number do
    number { 10.times.map { rand(1..9).to_s }.join }
    primary true
  end
end
