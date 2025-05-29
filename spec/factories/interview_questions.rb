FactoryBot.define do
  factory :interview_question do
    question { "Tell me about a time you overcame a technical challenge." }
    job_application
  end
end