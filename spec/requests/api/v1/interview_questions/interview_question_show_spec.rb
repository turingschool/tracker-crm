require "rails_helper"

RSpec.describe "Job Application #create & #index", type: :request do
  before(:each) do
    @user = User.create!(name: "Dolly Parton", email: "dollyP123@email.com", password: "Jolene123")

    @JoleneCopmany = Company.create!(user_id: @user.id, name: "JoleneCopmany", website: "jolenecopmany.com", street_address: "1100 Guitar Parkway", city: "MPittman Center", state: "TN", zip_code: "94043", notes: "Country Music")

    @job_application1 = JobApplication.create!(
      position_title: "Frontend Developer",
      date_applied: "2024-11-01",
      status: 0,
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
    it "Returns a list of 10 AI-Generated interview questions" do 
      get "/api/v1/users/#{@user.id}/job_applications/#{@job_application1.id}/interview_questions",
      headers: { "Authorization" => "Bearer #{@token}" }

      expect(response).to be_successful
      # expect(response.status).to eq(200)

      # job_application1_questions = JSON.parse(response.body, symbolize_names: true)

      
    end
  end


end
