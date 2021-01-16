FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "TEST#{n}"}
    sequence(:email) { |n| "test#{n}@test.com"}
    password { "password" }
    password_confirmation { "password" }
    admin { false }

    trait :admin do 
      admin { true }
    end

    factory :admin_user, traits: [:admin]
  end
end
