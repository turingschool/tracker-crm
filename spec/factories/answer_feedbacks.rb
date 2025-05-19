FactoryBot.define do
  factory :answer_feedback do
    interview_question { nil }
    answer { "MyText" }
    feedback { "MyText" }
  end
end
