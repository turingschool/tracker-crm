class AnswerFeedbackService
  def self.call(interview_question_id:, answer:)
    service = new(interview_question_id, answer)
    service.call
  end

  def initialize(interview_question_id, answer)
    @interview_question_id = interview_question_id
    @answer = answer
  end

  def call
    interview_question = InterviewQuestion.find_by(id: @interview_question_id)

    return { success: false, error: "Interview question not found." } unless interview_question

    prompt = build_feedback_prompt(@answer, interview_question.question)

    openai_response = OpenaiGateway.new.chat_with_gpt(prompt)

    return openai_response unless openai_response[:success]

    openai_feedback_text = openai_response[:data]

    answer_feedback = AnswerFeedback.create!(
      interview_question: interview_question,
      answer: @answer,
      feedback: openai_feedback_text
    )

    { success: true, data: answer_feedback }
  rescue => error
    { success: false, error: "An error occurred: #{error.message}" }
  end

  private

  def build_feedback_prompt(answer, question)
    <<~PROMPT
      You are a helpful and honest interview coach.
      Give clear, actionable feedback on this interview answer, focusing on strengths, weaknesses, and suggestions for improvement.
    
      Interview Question:
      "#{question}"
      
      Answer:
      "#{answer}"

      Provide your feedback in a single paragraph.
    PROMPT
  end
end