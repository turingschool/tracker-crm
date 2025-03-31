FactoryBot.define do
  factory :company do
    name { Faker::Company.name.gsub(/[^a-zA-Z0-9]/, ' ').squeeze(' ') }
    website { "http://www.#{name.gsub(/\s+/, '')}.com" }
    street_address { Faker::Address.street_address }
    city { Faker::Address.city }
    state { Faker::Address.state }
    zip_code { Faker::Address.zip_code[0,5] }
    notes { Faker::Company.catch_phrase }
    
    user
  end
end