require "rails_helper"

describe "Interview Questions Controller", type: :request do
  describe "index" do
    context "Happy Paths" do
      it "should return a 200 and the interview questions" do
        interview_question_1 = InterviewQuestion.create!(question: "What is your experience with Ruby?")
        interview_question_2 = InterviewQuestion.create!(question: "How do you handle version control?")
         get "/interview_questions"

         expect(response).to have_http_status(200)

        json_response = JSON.parse(response.body)
        expect(json_response.size).to eq(2)
        expect(json_response[0]['question']).to eq(interview_question_1.question)
        expect(json_response[1]['question']).to eq(interview_question_2.question)
      end
    end
  end
end