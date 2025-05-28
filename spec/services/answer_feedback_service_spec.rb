require 'rails_helper'

RSpec.describe AnswerFeedbackService do
  describe '.call' do
    it 'creates answer feedback when given a valid question and answer' do
      interview_question = create(:interview_question, question: "Tell me about a time you overcame a challenge.")
      user_answer = "When our server crashed right before launch, I coordinated with the ops team to identify the issue and deploy a hotfix within the hour."

      fake_gateway_response = {
        success: true,
        id: "ai-feedback-001",
        data: "Strong answer showing initiative and composure. You could enhance it by reflecting more on what you learned from the situation."
      }

      allow_any_instance_of(OpenaiGateway).to receive(:chat_with_gpt).and_return(fake_gateway_response)

      result = AnswerFeedbackService.call(interview_question_id: interview_question.id, answer: user_answer)

      expect(result[:success]).to eq(true)
      expect(result[:data]).to be_an(AnswerFeedback)
      expect(result[:data].feedback).to eq(fake_gateway_response[:data])
      expect(result[:data].answer).to eq(user_answer)
      expect(result[:data].interview_question_id).to eq(interview_question.id)
    end

    it 'returns an error if the interview question cannot be found' do
      result = AnswerFeedbackService.call(interview_question_id: -999, answer: "Some answer")
    
      expect(result[:success]).to eq(false)
      expect(result[:error]).to eq("Interview question not found.")
    end

    it 'returns a failure response if the OpenAI gateway call fails' do
      interview_question = create(:interview_question, question: "What’s your greatest strength?")
    
      allow_any_instance_of(OpenaiGateway).to receive(:chat_with_gpt).and_return({
        success: false,
        error: "Failed to fetch response from OpenAI."
      })
    
      result = AnswerFeedbackService.call(interview_question_id: interview_question.id, answer: "I'm very adaptable.")
    
      expect(result[:success]).to eq(false)
      expect(result[:error]).to eq("Failed to fetch response from OpenAI.")
    end
  end
end