require "rails_helper"

describe "Contacts Controller", type: :request do
  describe "#index action" do
    context "Happy Paths" do
      before(:each) do
        @user = User.create!(name: "Me", email: "its_me", password: "reallyGoodPass")
        @company = Company.create!(name: "Turing", website: "www.turing.com", street_address: "123 Main St", city: "Denver", state: "CO", zip_code: "80218", user_id: @user.id)
        Contact.create!(first_name: "John", last_name: "Smith", company_id: @company.id, email: "123@example.com", phone_number: "123-555-6789", notes: "Notes here...", user_id: @user.id)
        user_params = { email: "its_me", password: "reallyGoodPass" }
        post api_v1_sessions_path, params: user_params, as: :json
        @token = JSON.parse(response.body)["token"]
        
        @user2 = User.create!(name: "Jane", email: "email", password: "Password")
        user_params2 = { email: "email", password: "Password" }
        post api_v1_sessions_path, params: user_params2, as: :json
        @token2 = JSON.parse(response.body)["token"]
      end

      it "should return 200 and provide the appropriate contacts" do
        get api_v1_user_contacts_path(@user.id), headers: { "Authorization" => "Bearer #{@token}" }, as: :json

        expect(response).to be_successful
        json = JSON.parse(response.body, symbolize_names: true)[:data].first

        expect(json[:attributes][:first_name]).to eq("John")
        expect(json[:attributes][:last_name]).to eq("Smith")
        expect(json[:attributes][:email]).to eq("123@example.com")
        expect(json[:attributes][:phone_number]).to eq("123-555-6789")
        expect(json[:attributes][:notes]).to eq("Notes here...")
        expect(json[:attributes][:company_id]).to eq(@company.id)
      end

      it "should return 200 and an empty array if user has no contacts" do
        get api_v1_user_contacts_path(@user2.id), headers: { "Authorization" => "Bearer #{@token2}" }, as: :json

        expect(response).to be_successful
        json = JSON.parse(response.body, symbolize_names: true)
 
        expect(json[:data]).to eq([])
        expect(json[:message]).to eq("No contacts found")
      end

      it "should return 200 and all contacts associated with a company" do
        get api_v1_user_company_contacts_path(user_id: @user.id, company_id: @company.id), headers: { "Authorization" => "Bearer #{@token}" }, as: :json

        expect(response).to be_successful
        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body, symbolize_names: true)

        expect(json[:company][:data][:attributes][:name]).to eq("Turing")
        expect(json[:contacts][:data][0][:attributes][:last_name]).to eq("Smith")

      end
    end

    context "Sad Paths" do 
      before(:each) do
        @user = User.create!(name: "Me", email: "its_me", password: "reallyGoodPass")
        @company = Company.create!(name: "Turing", website: "www.turing.com", street_address: "123 Main St", city: "Denver", state: "CO", zip_code: "80218", user_id: @user.id)
        user_params = { email: "its_me", password: "reallyGoodPass" }
        post api_v1_sessions_path, params: user_params, as: :json
        @token = JSON.parse(response.body)["token"]
      end

      it "returns a 403 and an error message if no token is provided" do
        get api_v1_user_contacts_path(@user.id), as: :json
  
        expect(response).to have_http_status(:unauthorized)
        json = JSON.parse(response.body, symbolize_names: true)
  
        expect(json[:error]).to eq("Not authenticated")
      end
  
      it "returns a 403 and an error message if an invalid token is provided" do
        get api_v1_user_contacts_path(@user.id), headers: { "Authorization" => "Bearer invalid.token.here" }, as: :json
  
        expect(response).to have_http_status(:unauthorized)
        json = JSON.parse(response.body, symbolize_names: true)
  
        expect(json[:error]).to eq("Not authenticated")
      end
  
      it "returns a 403 and an error message if the token is expired" do
        user = User.create!(name: "Me", email: "email", password: "reallyGoodPass")
        expired_token = JWT.encode({ user_id: user.id, exp: 1.hour.ago.to_i }, Rails.application.secret_key_base, "HS256")
  
        get api_v1_user_contacts_path(user.id), headers: { "Authorization" => "Bearer #{expired_token}" }, as: :json
  
        expect(response).to have_http_status(:unauthorized)
        json = JSON.parse(response.body, symbolize_names: true)
  
        expect(json[:error]).to eq("Not authenticated")
      end

      it "returns a 404 and an error message if company ID is not found" do
        get api_v1_user_company_contacts_path(user_id: @user.id, company_id: 99999), headers: { "Authorization" => "Bearer #{@token}" }, as: :json

        expect(response).to_not be_successful
        expect(response).to have_http_status(:not_found)
        json = JSON.parse(response.body, symbolize_names: true)

        expect(json[:error]).to eq("Company not found or unauthorized access")
      end
    end
  end
end