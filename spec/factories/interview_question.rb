FactoryBot.define do
    factory :interview_question do
        question { Faker::Lorem.question }

        job_application
    end
end