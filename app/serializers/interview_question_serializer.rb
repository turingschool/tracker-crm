class InterviewQuestionSerializer
  include JSONAPI::Serializer
  attributes :question, :user_id
end