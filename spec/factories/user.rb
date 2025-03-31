FactoryBot.define do
  factory :user do
    name { "" }
    email { "" }
    password { "password123" }
    password_confirmation { "password123" }

    after(:build) do |user|
      user.assign_default_role
    end

    trait :admin do
      after(:build) do |user|
        user.set_role(:admin)
      end
    end
  end
end