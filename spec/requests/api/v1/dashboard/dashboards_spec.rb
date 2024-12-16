require 'rails_helper'

RSpec.describe "DashboardsController", type: :request do
  describe "GET #show" do

  let(:user) { User.create!(
    name: "Testy Tim", 
    email: "testytim420@email.com", 
    password: "12345") }

  let(:test_company) { Company.find_or_create_by!(
    user_id: user.id,
    name: "testCO", 
    website: "testcompany.com",
    street_address: "10 Amphitheatre Parkway", 
    city: "Mon View", state: "CO", 
    zip_code: "88888", notes: "Searchy engine")}

  let(:job_application1) { JobApplication.create!(
    position_title: "Jr. CTO",
    date_applied: "2024-10-31",
    status: 1,
    notes: "Fingers crossed!",
    job_description: "Looking for Turing grad/jr dev to be CTO",
    application_url: "www.example1.com",
    contact_information: "boss@example.com",
    company_id: test_company.id,
    user_id: user.id) }

  let(:job_application2) {JobApplication.create!(
    position_title: "Frontend Developer",
    date_applied: "2024-11-01",
    status: 0,
    notes: "Excited about this opportunity!",
    job_description: "Frontend Developer role with React expertise",
    application_url: "www.frontend.com",
    contact_information: "hiring@example.com",
    company_id: test_company.id,
    user_id: user.id) }

  let(:contact_params) { Contact.create!(
    first_name: "Josnny",
    last_name: "Smsith",
    company_id: test_company.id,
    email: "jonny@gmail.com",
    phone_number: "555-785-5555",
    notes: "Good contact for XYZ",
    user_id: user.id) }

    before(:each) do
      post "/api/v1/sessions", params: { email: user.email, password: user.password }, as: :json
      expect(response).to have_http_status(:ok)
      @token = JSON.parse(response.body)["token"]

      post "/api/v1/users/#{user.id}/companies", params: :test_company,
        headers: { "Authorization" => "Bearer #{@token}" }, as: :json
      post "/api/v1/users/#{user.id}/job_applications", params: job_application1,
        headers: { "Authorization" => "Bearer #{@token}" }, as: :json
      post "/api/v1/users/#{user.id}/job_applications", params: job_application2,
        headers: { "Authorization" => "Bearer #{@token}" }, as: :json
      post "/api/v1/users/#{user.id}/contacts", params: contact_params,
        headers: { "Authorization" => "Bearer #{@token}" }, as: :json
      end

    it "will display a user's dashboard and have correct attributes" do
      get "/api/v1/users/#{user.id}/dashboard",
        headers: { "Authorization" => "Bearer #{@token}" },as: :json

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(json[:id]).to eq(user.id.to_s)
      expect(json[:type]).to eq("dashboard")
      expect(json[:attributes][:name]).to eq("Testy Tim")
      expect(json[:attributes][:email]).to eq("testytim420@email.com")

      dashboard_summary = json[:attributes][:dashboard][:weekly_summary]
      
      expect(dashboard_summary[:job_applications].count).to eq(2)
      expect(dashboard_summary[:job_applications].first[:position_title]).to eq("Jr. CTO")
      expect(dashboard_summary[:job_applications].last[:position_title]).to eq("Frontend Developer")
      expect(dashboard_summary[:companies].first[:name]).to eq("testCO")
      expect(dashboard_summary[:companies].first[:website]).to eq("testcompany.com")
      expect(dashboard_summary[:contacts].count).to eq(1)
    end
  end
end
