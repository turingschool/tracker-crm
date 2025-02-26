class InterviewQuestionSerializer
  include JSONAPI::Serializer
  attributes :question, :job_application_id

  def self.format_questions(questions, response_id)
    {
      id: response_id,
      data: recommendations.map.with_index(1) do |question, index|
        {index: index,
        type: "interview_question",
        attributes: {
          question: question[:question] || question["question"],
          user_id: question[:job_application_id] || question["job_application_id"],
        }
      }
      end
    }

  end
end