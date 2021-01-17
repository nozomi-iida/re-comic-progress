FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "TEST#{n}"}
    sequence(:email) { |n| "test#{n}@test.com"}
    password { "password" }
    password_confirmation { "password" }
    admin { false }
    activated { true }
    activated_at { Time.zone.now }

    trait :admin do 
      admin { true }
    end

    trait :unactivated do 
      activated { false }
      email { "unactivated@test.com" }
    end

    factory :admin_user, traits: [:admin]
    factory :unactivated_user, traits: [:unactivated]
  end
end
