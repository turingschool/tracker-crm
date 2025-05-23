require 'rails_helper'

RSpec.describe "POST /api/v1/users/:user_id/job_applications/:job_application_id/interview_questions/:id/answer_feedback", type: :request do
  let(:user) { create(:user) }
  let(:job_application) { create(:job_application, user: user) }
  let(:interview_question) { create(:interview_question, job_application: job_application) }
  let(:token) do
    JWT.encode({ user_id: user.id, roles: user.roles.pluck(:name), exp: 24.hours.from_now.to_i }, Rails.application.secret_key_base)
  end
  let(:headers) do
    {
      "Authorization" => "Bearer #{token}",
      "Content-Type" => "application/json",
      "Accept" => "application/json"
    }
  end

  let(:valid_params) do
    {
      answer: "In a project, I had to integrate an unfamiliar API..."
    }.to_json
  end

  it "creates answer feedback and returns JSON response with status 201" do
    fake_feedback = build_stubbed(:answer_feedback, interview_question: interview_question)
  
    allow(AnswerFeedbackService).to receive(:call).and_return({
      success: true,
      data: fake_feedback
    })
  
    post "/api/v1/users/#{user.id}/job_applications/#{job_application.id}/interview_questions/#{interview_question.id}/answer_feedback",
      params: valid_params,
      headers: headers
  
    expect(response).to have_http_status(:created)
  
    json = JSON.parse(response.body, symbolize_names: true)
    expect(json[:data]).to have_key(:id)
    expect(json[:data][:attributes][:answer]).to eq(fake_feedback.answer)
    expect(json[:data][:attributes][:feedback]).to eq(fake_feedback.feedback)
  end
end