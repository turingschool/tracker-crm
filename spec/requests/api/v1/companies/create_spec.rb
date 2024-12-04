require "rails_helper"

describe "Companies API", type: :request do
  describe "Create#action" do 
    it "should be able to create a new company if user is logged in" do
      user = User.create!(name: "Melchor", email: "melchor@example.com", password: "password123")

      post api_v1_sessions_path, params: { email: user.email, password: "password123" }, as: :json
      
      expect(response).to have_http_status(:ok)

      token = JSON.parse(response.body)["token"]

      expect(token).to_not be_nil
      expect(token).to be_a(String)
      expect(token.split('.').length).to eq(3)

      decoded_token = JWT.decode(token, Rails.application.secret_key_base)[0]
      expect(decoded_token).to include("user_id")

      decoded_token = JWT.decode(token, Rails.application.secret_key_base)[0]
      expect(decoded_token["exp"]).to be > Time.now.to_i

      expect(token).to match(/\A[\w\-]+(\.[\w\-]+){2}\z/)
      
      company_params = {
        name: "New Company",
        website: "http://newcompany.com",
        street_address: "123 Main St",
        city: "New City",
        state: "NY",
        zip_code: "10001",
        notes: "This is a new company."
      }

      post "/api/v1/users/#{user.id}/companies", params: company_params, headers: { "Authorization" => "Bearer #{token}" }, as: :json
      
      expect(response).to have_http_status(:created)
      
      new_user_company = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(new_user_company[:id]).to be_a(String)
      expect(new_user_company[:type]).to be_a(String)
      expect(new_user_company[:attributes]).to be_a(Hash)
      expect(new_user_company[:attributes][:name]).to be_a(String)
      expect(new_user_company[:attributes][:website]).to be_a(String)
      expect(new_user_company[:attributes][:street_address]).to be_a(String)
      expect(new_user_company[:attributes][:city]).to be_a(String)
      expect(new_user_company[:attributes][:state]).to be_a(String)
      expect(new_user_company[:attributes][:zip_code]).to be_a(String)
      expect(new_user_company[:attributes][:notes]).to be_a(String)
    end
  end
end