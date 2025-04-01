FactoryBot.define do
  factory :contact do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { "#{first_name}.#{last_name}@#{company.name.gsub(/\s+/, '')}.com" }
    phone_number { Faker::PhoneNumber.cell_phone.gsub(/\D/, '')[0, 10] }
    notes { "Random contact notes" }

    transient do
      divider { '-' }
    end

    after(:build, :create) do |contact, evaluator|
      if contact.phone_number.length == 10
        contact.phone_number = "#{contact.phone_number[0,3]}#{evaluator.divider}#{contact.phone_number[3,3]}#{evaluator.divider}#{contact.phone_number[6,4]}"
      end
    end

    user
    company
  end
end