require "rails_helper"

describe "Companies API", type: :request do
  describe "Delete#action" do
    before(:each) do
      @user = User.create!(name: "Tom", email: "myspace_creator@email.com", password: "test123")

      post api_v1_sessions_path, params: { email: @user.email, password: "test123" }, as: :json
      @token = JSON.parse(response.body)["token"]

      @google = Company.create!(user_id: @user.id, name: "Google", website: "google.com", street_address: "1600 Amphitheatre Parkway", city: "Mountain View", state: "CA", zip_code: "94043", notes: "Search engine")

      @job_application = JobApplication.create!(
        position_title: "Software Engineer",
        date_applied: "2024-10-31",
        status: 1,
        notes: "Excited about this opportunity",
        job_description: "Develop cutting-edge software solutions",
        application_url: "www.example.com/job",
        company_id: @google.id,
        user_id: @user.id
      )
    end

    it "successfully deletes a company and its associated job applications" do
      expect(Company.find_by(id: @google.id)).not_to be_nil
      expect(JobApplication.find_by(id: @job_application.id)).not_to be_nil

      delete "/api/v1/users/#{@user.id}/companies/#{@google.id}", headers: { "Authorization" => "Bearer #{@token}", "Content-Type" => "application/json" }, as: :json

      expect(response).to have_http_status(:ok)
      expect(Company.find_by(id: @google.id)).to be_nil
      expect(JobApplication.find_by(id: @job_application.id)).to be_nil
    end

    it "returns an error if the company does not exist" do
      delete "/api/v1/users/#{@user.id}/companies/9999", headers: { "Authorization" => "Bearer #{@token}", "Content-Type" => "application/json" }, as: :json

      expect(response).to have_http_status(:not_found)
      json = JSON.parse(response.body, symbolize_names: true)

      expect(json[:error]).to eq("Company not found")
    end

    it "returns an unauthorized error if no token is provided" do
      delete "/api/v1/users/#{@user.id}/companies/#{@google.id}", as: :json

      expect(response).to have_http_status(:unauthorized)
      json = JSON.parse(response.body, symbolize_names: true)

      expect(json[:error]).to eq("Not authenticated")
    end

    it "returns an unauthorized error if an invalid token is provided" do
      delete "/api/v1/users/#{@user.id}/companies/#{@google.id}", headers: { "Authorization" => "Bearer invalid.token.here", "Content-Type" => "application/json" }, as: :json

      expect(response).to have_http_status(:unauthorized)
      json = JSON.parse(response.body, symbolize_names: true)

      expect(json[:error]).to eq("Not authenticated")
    end
  end
end
