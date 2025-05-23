require "rails_helper"

RSpec.describe "Job Application #create & #index", type: :request do
  before(:each) do
    @user = User.create!(name: "Dolly Parton", email: "dollyP123@email.com", password: "9to5")

    @JoleneCopmany = Company.create!(user_id: @user.id, name: "JoleneCopmany", website: "jolenecopmany.com", street_address: "1100 Guitar Parkway", city: "MPittman Center", state: "TN", zip_code: "94043", notes: "Country Music")

    @job_application1 = JobApplication.create!(
      position_title: "Frontend Developer",
      date_applied: "2024-11-01",
      status: :submitted,
      notes: "Excited about this opportunity!",
      job_description: "Frontend Developer role with React and Cypress expertise",
      application_url: "www.frontend.com",
      company: @JoleneCopmany,
      user: @user
    )
 
    post api_v1_sessions_path, params: { email: @user.email, password: "9to5" }, as: :json
    @token = JSON.parse(response.body)["token"]
  end

  context "#Happy path" do 
    it "Creates and returns a list of 10 AI-Generated interview questions if none already exist" do 
      VCR.use_cassette("generate_ai_questions") do
        get "/api/v1/users/#{@user.id}/job_applications/#{@job_application1.id}/interview_questions/fetch_or_create",
        headers: { "Authorization" => "Bearer #{@token}" }

        expect(response).to be_successful
        expect(response.status).to eq(200)

        job_application1_questions = JSON.parse(response.body, symbolize_names: true)

        expect(job_application1_questions[:data].length).to eq(10)
        expect(job_application1_questions[:data].first[:type]).to eq("interview_question")
        expect(job_application1_questions[:data].first[:attributes]).to have_key(:question)
      end      
    end

    it "Returns existing interview questions without calling OpenAI again" do 
      interview_question1 = InterviewQuestion.create!(
        job_application_id: @job_application1.id,
        question: "This is question 1."
      )
      interview_question2 = InterviewQuestion.create!(
        job_application_id: @job_application1.id,
        question: "This is question 2."
      )
     
     get "/api/v1/users/#{@user.id}/job_applications/#{@job_application1.id}/interview_questions/fetch_or_create",
      headers: { "Authorization" => "Bearer #{@token}" }

      expect(response).to be_successful
      expect(response.status).to eq(200)

      job_application1_question = JSON.parse(response.body, symbolize_names: true)

      expect(job_application1_question[:data].length).to eq(2)
      expect(job_application1_question[:data][0][:attributes][:question]).to eq("This is question 1.")
      expect(job_application1_question[:data][1][:attributes][:question]).to eq("This is question 2.")
    end
  end

  context "#Edge Cases" do 
    it "Returns 404 when job application doesn't exist" do
      non_existent_id = 999999999999999999
      get "/api/v1/users/#{@user.id}/job_applications/#{non_existent_id}/interview_questions/fetch_or_create",
      headers: { "Authorization" => "Bearer #{@token}" }
        
      expect(response).to have_http_status(:not_found)

      json = JSON.parse(response.body, symbolize_names: true)
      
      expect(json[:error]).to eq("Job application not found")
    end

    it "Handles OpenAI API failures gracefully" do
      allow_any_instance_of(OpenaiGateway).to receive(:chat_with_gpt).and_return({
      success: false,
      error: "API error"
      })

      get "/api/v1/users/#{@user.id}/job_applications/#{@job_application1.id}/interview_questions/fetch_or_create",
      headers: { "Authorization" => "Bearer #{@token}" }
      
      expect(response).to have_http_status(:bad_request)
      json = JSON.parse(response.body, symbolize_names: true)
      expect(json[:message]).to include("Failed to generate interview questions")
    end
  end
end
