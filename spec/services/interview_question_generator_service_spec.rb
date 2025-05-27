require 'rails_helper'

RSpec.describe InterviewQuestionGeneratorService do
  describe '.call' do
    it 'generates and saves interview questions when none exist' do
      job_app = create(:job_application, job_description: "We're hiring a backend dev")

      fake_ai_response = {
        success: true,
        id: "ai-response-123",
        data: "[\"What’s your experience with Rails?\", \"How do you optimize SQL queries?\", \"What are service objects used for?\", \"How do you handle background jobs?\", \"Explain Active Record callbacks\", \"What’s the difference between include and extend?\", \"How do you test APIs?\", \"What tools do you use for monitoring?\", \"Explain N+1 queries\", \"How do you scale a Rails app?\"]"
      }

      allow_any_instance_of(OpenaiGateway).to receive(:chat_with_gpt).and_return(fake_ai_response)

      result = InterviewQuestionGeneratorService.call(job_app)

      expect(result[:success]).to eq(true)
      expect(result[:data].length).to eq(10)
      expect(result[:data].first).to have_key(:question)
      expect(InterviewQuestion.count).to eq(10)
    end

    it 'returns an error if the OpenAI response is missing a parsable question array' do
      job_app = create(:job_application, job_description: "Looking for a software engineer.")
    
      fake_bad_response = {
        success: true,
        id: "ai-response-456",
        data: "Here are some interview questions you might ask a candidate, hope this helps!"
      }
    
      allow_any_instance_of(OpenaiGateway).to receive(:chat_with_gpt).and_return(fake_bad_response)
    
      result = InterviewQuestionGeneratorService.call(job_app)
    
      expect(result[:success]).to eq(false)
      expect(result[:error]).to be_a(ErrorMessage)
      expect(result[:error].message).to eq("Unexpected response format from OpenAI.")
    end
  end
end