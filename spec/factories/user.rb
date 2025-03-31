FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { "#{name.gsub(' ', '.')}@gmail.com" }
    password { "password#{Faker::Number.within(range: 1..100)}" }

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