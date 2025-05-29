class AnswerFeedbackSerializer
  include JSONAPI::Serializer
  
  attributes :id, :answer, :feedback, :interview_question_id, :created_at
end
