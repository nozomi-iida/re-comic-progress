FactoryBot.define do
  factory :comic do
    sequence(:title) { |n| "test#{n}"}
    volume { 1 }
    user
    sequence(:created_at) { |n| n.hours.ago }

    trait :latest do 
      created_at { Time.zone.now }
    end

    factory :latest_comic, traits: [:latest]
  end
end
