require "rails_helper"

RSpec.describe "Job Application Destory", type: :request do
  before(:each) do
    @user = User.create!(name: "Dolly Parton", email: "dollyP123@email.com", password: "Jolene123")

    @google = Company.create!(user_id: @user.id, name: "Google", website: "google.com", street_address: "1600 Amphitheatre Parkway", city: "Mountain View", state: "CA", zip_code: "94043", notes: "Search engine")

    @facebook = Company.create!(user_id: @user.id, name: "Facebook", website: "facebook.com", street_address: "1 Hacker Way", city: "Menlo Park", state: "CA", zip_code: "94025", notes: "Social media")

    @amazon = Company.create!(user_id: @user.id, name: "Amazon", website: "amazon.com", street_address: "410 Terry Ave N", city: "Seattle", state: "WA", zip_code: "98109", notes: "E-commerce")

    @job_application1 = JobApplication.create!(
      position_title: "Jr. CTO",
      date_applied: "2024-10-31",
      status: 1,
      notes: "Fingers crossed!",
      job_description: "Looking for Turing grad/jr dev to be CTO",
      application_url: "www.example1.com",
      company: @google,
      user: @user
    )

    @job_application2 = JobApplication.create!(
      position_title: "Frontend Developer",
      date_applied: "2024-11-01",
      status: 0,
      notes: "Excited about this opportunity!",
      job_description: "Frontend Developer role with React expertise",
      application_url: "www.frontend.com",
      company: @google,
      user: @user
    )
 
    post api_v1_sessions_path, params: { email: @user.email, password: "Jolene123" }, as: :json
    @token = JSON.parse(response.body)["token"]
  end

  let(:job_application_params) do
    {
      position_title: "Jr. CTO",
      date_applied: "2024-10-31",
      status: 1,
      notes: "Fingers crossed!",
      job_description: "Looking for Turing grad/jr dev to be CTO",
      application_url: "www.example.com",
      company_id: @google.id
    }
  end

  context "#Create Delete Job Application" do
    it "Deletes a job application" do
      post "/api/v1/users/#{@user.id}/job_applications",
        params: { job_application: job_application_params },
        headers: { "Authorization" => "Bearer #{@token}" },
        as: :json

      expect(response).to be_successful
      expect(response.status).to eq(200)

      jobApp = JSON.parse(response.body, symbolize_names: true)

      # SAD PATH - No job id or invalid job id
      delete "/api/v1/users/#{@user.id}/job_applications",
        headers: { "Authorization" => "Bearer #{@token}" },
        as: :json
      
      expect(response).to have_http_status(404)

      delete "/api/v1/users/#{@user.id}/job_applications/9999",
           headers: { "Authorization" => "Bearer #{@token}" },
           as: :json
           
      expect(response).to have_http_status(404)

      # HAPPY PATH
      delete "/api/v1/users/#{@user.id}/job_applications/#{JobApplication.last.id}",
        headers: { "Authorization" => "Bearer #{@token}" },
        as: :json
      
      expect(response).to have_http_status(:ok)
    end
  end
end