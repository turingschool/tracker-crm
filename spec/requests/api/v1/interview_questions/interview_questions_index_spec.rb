require "rails_helper"

describe "InterviewQuestionsController", type: :request do
  describe "GET /api/v1/interview_questions" do
    context "when there are interview questions in the database" do
      it "returns a 200 status code and the list of interview questions" do
        user = User.create!(name: "Test User", email: "testuser@example.com", password: "password")
        interview_question_1 = InterviewQuestion.create!(question: "What is your experience with Ruby?",  user: user)
        interview_question_2 = InterviewQuestion.create!(question: "How do you handle version control?", user: user)

        post '/api/v1/sessions', params: { email: "testuser@example.com", password: "password" }
        token = JSON.parse(response.body)["token"]

        get "/api/v1/interview_questions", headers: { "Authorization" => "Bearer #{token}" }

        expect(response).to have_http_status(200)
        json_response = JSON.parse(response.body)

        expect(json_response.size).to eq(2)
        expect(json_response[0]['question']).to eq(interview_question_1.question)
        expect(json_response[1]['question']).to eq(interview_question_2.question)
      end
    end
  
  end
end
