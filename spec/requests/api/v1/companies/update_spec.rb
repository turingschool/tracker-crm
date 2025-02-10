require "rails_helper"

RSpec.describe "Update Company", type: :request do
  describe "Update Company Endpoint" do
    let!(:user) { User.create!(name: "Tom", email: "myspace_creator@email.com", password: "test123") }
    let!(:company) { Company.create!(user_id: user.id, name: "Old Company", website: "oldwebsite.com", street_address: "123 Old St", city: "Oldtown", state: "OT", zip_code: "12345", notes: "Old notes") }

    before do
      post api_v1_sessions_path, params: { email: user.email, password: "test123" }, as: :json
      @token = JSON.parse(response.body)["token"]
    end

    it "updates a company successfully" do
      update_params = {
        name: "Updated Company",
        website: "https://updatedwebsite.com",
        notes: "Updated notes"
      }

      patch "/api/v1/users/#{user.id}/companies/#{company.id}", 
        params: update_params, 
        headers: { "Authorization" => "Bearer #{@token}", "Content-Type" => "application/json" }, 
        as: :json

      expect(response).to be_successful
      json = JSON.parse(response.body, symbolize_names: true)[:data]
      expect(json[:attributes][:name]).to eq("Updated Company")
      expect(json[:attributes][:website]).to eq("https://updatedwebsite.com")
      expect(json[:attributes][:notes]).to eq("Updated notes")
    end

    it "returns an error if the company does not exist" do
      patch "/api/v1/users/#{user.id}/companies/99999",
        params: { name: "New Name" },
        headers: { "Authorization" => "Bearer #{@token}", "Content-Type" => "application/json" },
        as: :json

      expect(response).to have_http_status(:not_found)
      json = JSON.parse(response.body, symbolize_names: true)

      expect(json[:message]).to eq("Company not found")
      expect(json[:status]).to eq(404)
    end

    it "returns a validation error if required fields for name are missing" do
      invalid_params = { name: "" }

      patch "/api/v1/users/#{user.id}/companies/#{company.id}",
        params: invalid_params,
        headers: { "Authorization" => "Bearer #{@token}", "Content-Type" => "application/json" },
        as: :json

      expect(response).to have_http_status(:unprocessable_entity)
      json = JSON.parse(response.body, symbolize_names: true)

      expect(json[:message]).to eq("Name can't be blank")
      expect(json[:status]).to eq(422)
    end

    it "returns a validation error if required fields for state are missing" do
      invalid_params = { state: "" }

      patch "/api/v1/users/#{user.id}/companies/#{company.id}",
        params: invalid_params,
        headers: { "Authorization" => "Bearer #{@token}", "Content-Type" => "application/json" },
        as: :json

      expect(response).to have_http_status(:unprocessable_entity)
      json = JSON.parse(response.body, symbolize_names: true)

      expect(json[:message]).to eq("State can't be blank")
      expect(json[:status]).to eq(422)
    end

    it "returns a 400 bad request error if no updates are sent in the request" do
      patch "/api/v1/users/#{user.id}/companies/#{company.id}",
        params: {},
        headers: { "Authorization" => "Bearer #{@token}", "Content-Type" => "application/json" },
        as: :json
    
      expect(response).to have_http_status(:bad_request)
      json = JSON.parse(response.body, symbolize_names: true)
    
      expect(json[:message]).to eq("No updates provided")
      expect(json[:status]).to eq(400)
    end    
  end
end
