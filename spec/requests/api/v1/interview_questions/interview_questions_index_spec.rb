require 'rails_helper'

RSpec.describe 'InterviewQuestions API', type: :request do
  describe 'GET /api/v1/interview_questions' do
    context 'happy path' do
      before do

        user = User.create!(name: "Test User", email: "testuser@example.com", password: "password")
        company = Company.create!(name: "Test Company", user: user)
        job_application = JobApplication.create!(
          position_title: "Software Engineer",
          date_applied: Date.today,
          status: 0,
          job_description: "We are looking for a software engineer with Ruby experience.",
          application_url: "http://example.com/job_application",
          company: company,
          user: user
        )

        @interview_question_1 = InterviewQuestion.create!(question: "What is your experience with Ruby?", job_application: job_application)
        @interview_question_2 = InterviewQuestion.create!(question: "How do you handle version control?", job_application: job_application)

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
