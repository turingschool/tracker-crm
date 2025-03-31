FactoryBot.define do
  factory :user do
    name { "first_name last_name" }
    email { "#{name.gsub(' ', '.')}@gmail.com" }
    password { "password#{rand(100)}" }

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