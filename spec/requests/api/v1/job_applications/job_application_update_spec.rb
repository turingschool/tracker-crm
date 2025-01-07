require "rails_helper"

RSpec.describe "Job Application #update", type: :request do
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
      position_title: "Sr. CTO",
      date_applied: "2024-10-31",
      status: 3,
      notes: "Fingers crossed!",
      job_description: "Looking for Turing grad/jr dev to be CTO",
      application_url: "www.example.com",
      company_id: @google.id
    }
  end

  context "#Update happy path" do
    it "Returns expected updated fields" do
      patch "/api/v1/users/#{@user.id}/job_applications/#{@job_application1.id}",
        params: { job_application: job_application_params },
        headers: { "Authorization" => "Bearer #{@token}" },
        as: :json

      expect(response).to be_successful
      expect(response.status).to eq(200)

      job_app = JSON.parse(response.body, symbolize_names: true)
    #   binding.pry
      expect(job_app[:data][:type]).to eq("job_application")
      expect(job_app[:data][:id].to_i).to eq(@job_application1.id)
      expect(job_app[:data][:attributes][:position_title]).to eq(job_application_params[:position_title])
      expect(job_app[:data][:attributes][:date_applied]).to eq(job_application_params[:date_applied])
      expect(job_app[:data][:attributes][:status]).to eq(job_application_params[:status])
      expect(job_app[:data][:attributes][:notes]).to eq(job_application_params[:notes])
      expect(job_app[:data][:attributes][:job_description]).to eq(job_application_params[:job_description])
      expect(job_app[:data][:attributes][:application_url]).to eq(job_application_params[:application_url])
      expect(job_app[:data][:attributes][:company_id]).to eq(job_application_params[:company_id])
      expect(job_app[:data][:attributes][:company_name]).to eq(@google.name)
      expect(job_app[:data][:attributes][:updated_at]).to match(/^\d{4}-\d{2}-\d{2}$/)
    end
  end

#   context "#Create sad path" do
#     it "Returns error serializer if params are missing attribute" do
#       post "/api/v1/users/#{@user.id}/job_applications",
#         params: {
#           date_applied: "2024-10-31",
#           status: 1,
#           job_description: "Looking for Turing grad/jr dev to be CTO",
#           application_url: "www.example.com",
#           company_id: 1
#         },
#         headers: { "Authorization" => "Bearer #{@token}" },
#         as: :json

#       expect(response).to_not be_successful
#       expect(response).to have_http_status(:bad_request)

#       json = JSON.parse(response.body, symbolize_names: true)

#       expect(json[:message]).to eq("Company must exist and Position title can't be blank")
#       expect(json[:status]).to eq(400)
#     end

#     it "Returns error serializer if param keys are missing value" do
#       post "/api/v1/users/#{@user.id}/job_applications",
#         params: {
#           position_title: "",
#           date_applied: "2024-10-31",
#           status: 1,
#           notes: "Fingers crossed!",
#           job_description: "Looking for Turing grad/jr dev to be CTO",
#           application_url: "www.example.com",
#           company_id: 1
#         },
#         headers: { "Authorization" => "Bearer #{@token}" },
#         as: :json

#       expect(response).to_not be_successful
#       expect(response).to have_http_status(:bad_request)

#       json = JSON.parse(response.body, symbolize_names: true)

#       expect(json[:message]).to eq("Company must exist and Position title can't be blank")
#       expect(json[:status]).to eq(400)
#     end
#   end
end