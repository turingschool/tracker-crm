require "rails_helper"

RSpec.describe "Users #Create", type: :request do
  describe "endpoints" do
    context "request is valid" do
      it "returns 201 Created and provides expected fields" do
        user = build(:user)
        post api_v1_users_path, params: { 
          name: user.name,
          email: user.email,
          password: user.password,
          password_confirmation: user.password
        }, as: :json
        
        expect(response).to have_http_status(:created)
        json = JSON.parse(response.body, symbolize_names: true)
        expect(json[:data][:type]).to eq("user")
        expect(json[:data][:id]).to eq(User.last.id.to_s)
        expect(json[:data][:attributes][:name]).to eq(user.name)
        expect(json[:data][:attributes][:email]).to eq(user.email)
        expect(json[:data][:attributes]).to_not have_key(:password)
        expect(json[:data][:attributes]).to_not have_key(:password_confirmation)
      end
    end

    context "request is invalid" do
      it "returns an error for non-unique email" do
        existing_user = create(:user)
        
        post api_v1_users_path, params: { 
          name: "New User",
          email: existing_user.email,
          password: "password123",
          password_confirmation: "password123"
        }, as: :json

        json = JSON.parse(response.body, symbolize_names: true)
        expect(response).to have_http_status(:bad_request)
        expect(json[:message]).to eq("Email has already been taken")
        expect(json[:status]).to eq(400)
      end

      it "returns an error when password does not match password confirmation" do
        user = build(:user)
        
        post api_v1_users_path, params: { 
          name: user.name,
          email: user.email,
          password: "password123",
          password_confirmation: "different_password"
        }, as: :json

        json = JSON.parse(response.body, symbolize_names: true)
        expect(response).to have_http_status(:bad_request)
        expect(json[:message]).to eq("Password confirmation doesn't match Password")
        expect(json[:status]).to eq(400)
      end

      it "returns an error for missing field" do
        post api_v1_users_path, params: { 
          name: "Test User",
          email: "",
          password: "password123",
          password_confirmation: "password123"
        }, as: :json

        json = JSON.parse(response.body, symbolize_names: true)
        expect(response).to have_http_status(:bad_request)
        expect(json[:message]).to eq("Email can't be blank")
        expect(json[:status]).to eq(400)
      end
    end
  end
end