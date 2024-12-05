require "rails_helper"

RSpec.describe "Job Application #create", type: :request do
  describe "Create Job Application" do
    let(:job_application_params) do
      {
        position_title: "Jr. CTO",
        date_applied: "2024-10-31",
        status: 1,
        notes: "Fingers crossed!",
        job_description: "Looking for Turing grad/jr dev to be CTO",
        application_url: "www.example.com",
        contact_information: "boss@example.com",
        company_id: 1
      }
    end

    context "happy path" do
      it "Returns expected fields" do
        post "/api/v1/job_applications", 
        params: { job_application: job_application_params }, 
        as: :json

        puts "Response Status: #{response.status}" # Logs HTTP status
        puts "Response Body: #{response.body}" # Logs HTTP response body
        require 'pry'; binding.pry

        expect(response).to be_successful
        expect(response.status).to eq(200)

        response = JSON.parse(response.body, symbolize_names: true)
        expect(response[:data][:type]).to eq("job_application")
        expect(response[:data][:id]).to eq(JobApplication.last.id.to_s)
        expect(response[:data][:attributes][:position_title]).to eq(job_application_params[:position_title])
      end
    end
  end
end