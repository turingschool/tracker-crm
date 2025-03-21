require "rails_helper"

RSpec.describe "Companies Index", type: :request do
  describe "Get All Companies Endpoint" do
    let!(:user) { User.create!(name: "Tom", email: "myspace_creator@email.com", password: "test123") }
    
    before do
      post api_v1_sessions_path, params: { email: user.email, password: "test123" }, as: :json
      @token = JSON.parse(response.body)["token"]
    end

    it "retrieves all companies but does not share any sensitive data" do
      Company.create!(user_id: user.id, name: "Google", website: "google.com", street_address: "1600 Amphitheatre Parkway", city: "Mountain View", state: "CA", zip_code: "94043", notes: "Search engine")
      Company.create!(user_id: user.id, name: "Facebook", website: "facebook.com", street_address: "1 Hacker Way", city: "Menlo Park", state: "CA", zip_code: "94025", notes: "Social media")
      Company.create!(user_id: user.id, name: "Amazon", website: "amazon.com", street_address: "410 Terry Ave N", city: "Seattle", state: "WA", zip_code: "98109", notes: "E-commerce")

      get "/api/v1/users/#{user.id}/companies", headers: { "Authorization" => "Bearer #{@token}" }, as: :json

      expect(response).to be_successful
      json = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(json.count).to eq(3)
      json.each do |company|
        expect(company[:attributes][:name]).to be_a(String)
        expect(company[:attributes][:website]).to be_a(String)
        expect(company[:attributes][:street_address]).to be_a(String)
        expect(company[:attributes][:city]).to be_a(String)
        expect(company[:attributes][:state]).to be_a(String)
        expect(company[:attributes][:zip_code]).to be_a(String)
        expect(company[:attributes][:notes]).to be_a(String)
      end
    end

    it "returns an empty array if no companies are found" do
      get "/api/v1/users/#{user.id}/companies", headers: { "Authorization" => "Bearer #{@token}" }, as: :json

      expect(response).to be_successful
      json = JSON.parse(response.body, symbolize_names: true)

      expect(json[:data]).to eq([])
      expect(json[:message]).to eq("No companies found")
    end

    it "returns an error message if no token is provided" do
      get "/api/v1/users/#{user.id}/companies", as: :json

      expect(response).to have_http_status(:unauthorized)
      json = JSON.parse(response.body, symbolize_names: true)

      expect(json[:error]).to eq("Not authenticated")
    end

    it "returns an error message if an invalid token is provided" do
      get "/api/v1/users/#{user.id}/companies", headers: { "Authorization" => "Bearer invalid.token.here" }, as: :json

      expect(response).to have_http_status(:unauthorized)
      json = JSON.parse(response.body, symbolize_names: true)

      expect(json[:error]).to eq("Not authenticated")
    end

    it "returns an error message if the token is expired" do
      expired_token = JWT.encode({ user_id: user.id, exp: 1.hour.ago.to_i }, Rails.application.secret_key_base, "HS256")

      get "/api/v1/users/#{user.id}/companies", headers: { "Authorization" => "Bearer #{expired_token}" }, as: :json

      expect(response).to have_http_status(:unauthorized)
      json = JSON.parse(response.body, symbolize_names: true)

      expect(json[:error]).to eq("Not authenticated")
    end
  end
end