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
  end
end