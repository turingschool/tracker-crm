FactoryBot.define do
  factory :answer_feedback do
    answer { "In a project, I had to integrate an unfamiliar API..." }
    feedback { "This shows initiative, but consider including a reflection on what you learned." }
    interview_question
  end
end