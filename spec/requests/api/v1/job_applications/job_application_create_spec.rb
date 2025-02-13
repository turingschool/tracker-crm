require "rails_helper"

RSpec.describe "Job Application #create & #index", type: :request do
  before(:each) do
    @user = User.create!(name: "Dolly Parton", email: "dollyP123@email.com", password: "Jolene123")

    @google = Company.create!(user_id: @user.id, name: "Google", website: "google.com", street_address: "1600 Amphitheatre Parkway", city: "Mountain View", state: "CA", zip_code: "94043", notes: "Search engine")

    @facebook = Company.create!(user_id: @user.id, name: "Facebook", website: "facebook.com", street_address: "1 Hacker Way", city: "Menlo Park", state: "CA", zip_code: "94025", notes: "Social media")

    @amazon = Company.create!(user_id: @user.id, name: "Amazon", website: "amazon.com", street_address: "410 Terry Ave N", city: "Seattle", state: "WA", zip_code: "98109", notes: "E-commerce")

    @contact = Contact.create!(user_id: @user.id, first_name: "John", last_name: "Doe", email: "john@example.com", phone_number: "123-456-7890")

    @job_application1 = JobApplication.create!(
      position_title: "Jr. CTO",
      date_applied: "2024-10-31",
      status: 1,
      notes: "Fingers crossed!",
      job_description: "Looking for Turing grad/jr dev to be CTO",
      application_url: "www.example1.com",
      company: @google,
      user: @user,
      contact_id: @contact.id
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
      company_id: @google.id,
      contact_id: @contact.id
    }
  end

  context "#Create happy path" do
    it "Returns expected fields" do
      post "/api/v1/users/#{@user.id}/job_applications",
        params: { job_application: job_application_params },
        headers: { "Authorization" => "Bearer #{@token}" },
        as: :json

      expect(response).to be_successful
      expect(response.status).to eq(200)

      jobApp = JSON.parse(response.body, symbolize_names: true)
      
      expect(jobApp[:data][:type]).to eq("job_application")
      expect(jobApp[:data][:id]).to eq(JobApplication.last.id.to_s)
      expect(jobApp[:data][:attributes][:position_title]).to eq(job_application_params[:position_title])
      expect(jobApp[:data][:attributes][:date_applied]).to eq(job_application_params[:date_applied])
      expect(jobApp[:data][:attributes][:status]).to eq(job_application_params[:status])
      expect(jobApp[:data][:attributes][:notes]).to eq(job_application_params[:notes])
      expect(jobApp[:data][:attributes][:job_description]).to eq(job_application_params[:job_description])
      expect(jobApp[:data][:attributes][:application_url]).to eq(job_application_params[:application_url])
      expect(jobApp[:data][:attributes][:company_id]).to eq(job_application_params[:company_id])
      expect(jobApp[:data][:attributes][:company_name]).to eq(@google.name)
      puts jobApp

      expect(jobApp[:data][:attributes][:contact_id]).to eq(@contact.id)
    end
  end

  context "#Create sad path" do
    it "Returns error serializer if params are missing attribute" do
      post "/api/v1/users/#{@user.id}/job_applications",
        params: {
          date_applied: "2024-10-31",
          status: 1,
          job_description: "Looking for Turing grad/jr dev to be CTO",
          application_url: "www.example.com",
          company_id: 1
        },
        headers: { "Authorization" => "Bearer #{@token}" },
        as: :json

      expect(response).to_not be_successful
      expect(response).to have_http_status(:bad_request)

      json = JSON.parse(response.body, symbolize_names: true)

      expect(json[:message]).to eq("Company must exist and Position title can't be blank")
      expect(json[:status]).to eq(400)
    end

    it "Returns error serializer if param keys are missing value" do
      post "/api/v1/users/#{@user.id}/job_applications",
        params: {
          position_title: "",
          date_applied: "2024-10-31",
          status: 1,
          notes: "Fingers crossed!",
          job_description: "Looking for Turing grad/jr dev to be CTO",
          application_url: "www.example.com",
          company_id: 1
        },
        headers: { "Authorization" => "Bearer #{@token}" },
        as: :json

      expect(response).to_not be_successful
      expect(response).to have_http_status(:bad_request)

      json = JSON.parse(response.body, symbolize_names: true)

      expect(json[:message]).to eq("Company must exist and Position title can't be blank")
      expect(json[:status]).to eq(400)
    end
  end

  context "#Index happy path" do
    it "returns all job applications for the logged-in user" do
      get "/api/v1/users/#{@user.id}/job_applications",
          headers: { "Authorization" => "Bearer #{@token}" },
          as: :json
    
      expect(response).to be_successful
      expect(response.status).to eq(200)
    
      job_applications = JSON.parse(response.body, symbolize_names: true)
    
      expect(job_applications[:data]).to be_an(Array)
      expect(job_applications[:data].size).to eq(2)
    
      first_application = job_applications[:data].first[:attributes]
      expect(first_application[:position_title]).to eq(@job_application1.position_title)
      expect(Date.parse(first_application[:date_applied])).to eq(@job_application1.date_applied) # Parse response to Date
      expect(first_application[:status]).to eq(@job_application1.status)
      expect(first_application[:notes]).to eq(@job_application1.notes)
      expect(first_application[:job_description]).to eq(@job_application1.job_description)
      expect(first_application[:application_url]).to eq(@job_application1.application_url)
      expect(first_application[:company_name]).to eq(@google.name)
      expect(first_application[:company_id]).to eq(@google.id)
    end
  end

  context "#Index sad path" do
    it "returns a 401 error if the user is not authenticated" do
      get "/api/v1/users/#{@user.id}/job_applications", as: :json

      expect(response).to_not be_successful
      expect(response).to have_http_status(:unauthorized)

      json = JSON.parse(response.body, symbolize_names: true)

      expect(json[:error]).to eq("Not authenticated")
    end
  end
end