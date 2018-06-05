FactoryBot.define do
  factory :tag, class: ActsAsTaggableOn::Tag do |f|
    f.sequence(:name) { |n| "tag#{n}" }
  end
end