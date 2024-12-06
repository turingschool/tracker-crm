require "rails_helper"

RSpec.describe "Job Application #create", type: :request do
  describe "Create Job Application" do
    before(:each) do
      @user = User.create!(name: "Dolly Parton", email: "dollyP123@email.com", password: "Jolene123")

      @google = Company.create!(user_id: @user.id, name: "Google", website: "google.com", street_address: "1600 Amphitheatre Parkway", city: "Mountain View", state: "CA", zip_code: "94043", notes: "Search engine")

      @facebook = Company.create!(user_id: @user.id, name: "Facebook", website: "facebook.com", street_address: "1 Hacker Way", city: "Menlo Park", state: "CA", zip_code: "94025", notes: "Social media")

      @amazon = Company.create!(user_id: @user.id, name: "Amazon", website: "amazon.com", street_address: "410 Terry Ave N", city: "Seattle", state: "WA", zip_code: "98109", notes: "E-commerce")
    end
    let(:job_application_params) do
      {
        position_title: "Jr. CTO",
        date_applied: "2024-10-31",
        status: 1,
        notes: "Fingers crossed!",
        job_description: "Looking for Turing grad/jr dev to be CTO",
        application_url: "www.example.com",
        contact_information: "boss@example.com",
        company_id: @google.id
      }
    end

    context "happy path" do
      it "Returns expected fields" do
        post "/api/v1/users/#{@user.id}/job_applications", 
        params: { job_application: job_application_params }
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
        expect(jobApp[:data][:attributes][:contact_information]).to eq(job_application_params[:contact_information])
        expect(jobApp[:data][:attributes][:company_id]).to eq(job_application_params[:company_id])      
      end
    end

    context "sad path" do
      it "Returns error serializer if params are missing attribute" do
        post "/api/v1/users/#{@user.id}/job_applications", 
        params: {
          date_applied: "2024-10-31",
          status: 1,
          notes: "Fingers crossed!",
          job_description: "Looking for Turing grad/jr dev to be CTO",
          application_url: "www.example.com",
          contact_information: "boss@example.com",
          company_id: 1
        }, 
        as: :json

        expect(response).to_not be_successful
        expect(response).to have_http_status(:bad_request)
        expect(response.status).to eq(400)

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
          contact_information: "boss@example.com",
          company_id: 1
        }, 
        as: :json

        expect(response).to_not be_successful
        expect(response).to have_http_status(:bad_request)
        expect(response.status).to eq(400)

        json = JSON.parse(response.body, symbolize_names: true)

        expect(json[:message]).to eq("Company must exist and Position title can't be blank")
        expect(json[:status]).to eq(400)
      end
    end
  end
end