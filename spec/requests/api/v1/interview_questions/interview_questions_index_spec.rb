require 'rails_helper'

RSpec.describe 'InterviewQuestions API', type: :request do
  describe 'GET /api/v1/interview_questions' do
    context 'happy path' do
      before do

        user = User.create!(name: "Test User", email: "testuser@example.com", password: "password")
        @interview_question_1 = InterviewQuestion.create!(question: "What is your experience with Ruby?", user: user)
        @interview_question_2 = InterviewQuestion.create!(question: "How do you handle version control?", user: user)

        post '/api/v1/sessions', params: { email: "testuser@example.com", password: "password" }
        @token = JSON.parse(response.body)["token"]
      end
      
      it 'returns a list of interview questions' do
        VCR.use_cassette("openai_gateway_success 2") do

          get "/api/v1/interview_questions", 
          params: { description: "Software Engineer position" }, 
          headers: { "Authorization" => "Bearer #{@token}" }
          
          expect(response).to be_successful
          
          json = JSON.parse(response.body, symbolize_names: true)
          expect(json.size).to eq(2)
          expect(json[0][:question]).to eq(@interview_question_1.question)
          expect(json[1][:question]).to eq(@interview_question_2.question)
        end
      end
    end
  end
end
