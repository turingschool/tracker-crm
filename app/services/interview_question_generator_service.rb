class InterviewQuestionGeneratorService
  def self.call(job_application)
    existing_questions = InterviewQuestion.where(job_application_id: job_application.id)

    if existing_questions.present?
      return {
        success: true, 
        data: InterviewQuestionSerializer.format_questions(existing_questions, "existing-questions-for-#{job_application.id}")
      }
    end

    ai_response = OpenaiGateway.new.generate_interview_questions(job_application.job_description)


    if ai_response[:success]
      created_questions = ai_response[:data].map do |question_text|
        InterviewQuestion.create!(
          job_application_id: job_application.id, 
          question: question_text
        )
      end
      {
        success: true, 
        data: InterviewQuestionSerializer.format_questions(created_questions, ai_response[:id])
      }
    else
      {
        success: false,
        error: ErrorMessage.new("Failed to generate interview questions.", 400)
      }
    end
  end
end