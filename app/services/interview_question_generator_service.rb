class InterviewQuestionGeneratorService
  def self.call(job_application)
    existing_questions = InterviewQuestion.where(job_application_id: job_application.id)

    if existing_questions.present?
      return {
        success: true, 
        data: InterviewQuestionSerializer.format_questions(
          existing_questions,
          "existing-questions-for-#{job_application.id}"
        )
      }
    end

    prompt = build_question_prompt(job_application.job_description)
    ai_response = OpenaiGateway.new.chat_with_gpt(prompt)

    if ai_response[:success]
      raw_content = ai_response[:data]
      cleaned_content = raw_content.match(/\[.*\]/m)&.to_s
    
      if cleaned_content
        parsed_questions = JSON.parse(cleaned_content)

        created_questions = parsed_questions.map do |question_text|
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
          error: ErrorMessage.new("Unexpected response format from OpenAI.", 400)
        }
      end
    else
      {
        success: false,
        error: ErrorMessage.new("Failed to generate interview questions.", 400)
      }
    end
  end

  private

  def self.build_question_prompt(description)
    <<~PROMPT
      Please generate 10 practice interview questions based on the following job description:

      "#{description}"

      ONLY return a JSON array of strings with no extra formatting.
    PROMPT
  end
end