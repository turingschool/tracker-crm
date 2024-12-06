require "rails_helper"

describe "Contacts Controller", type: :request do
  describe "#index action" do
    context "returns a list of all contacts for a specific user" do
      before(:each) do
        @user = User.create!(name: "Me", email: "its_me", password: "reallyGoodPass")
        Contact.create!(first_name: "John", last_name: "Smith", company: "Turing", email: "123@example.com", phone_number: "(123) 555-6789", notes: "Notes here...", user_id: @user.id)
        user_params = { email: "its_me", password: "reallyGoodPass" }
        post api_v1_sessions_path, params: user_params, as: :json
        @token = JSON.parse(response.body)["token"]
        
        @user2 = User.create!(name: "Jane", email: "email", password: "Password")
        user_params2 = { email: "email", password: "Password" }
        post api_v1_sessions_path, params: user_params2, as: :json
        @token2 = JSON.parse(response.body)["token"]
      end

      it "should return 200 and provide the appropriate contacts" do
        get api_v1_contacts_path, headers: { "Authorization" => "Bearer #{@token}" }, as: :json

        expect(response).to be_successful
        json = JSON.parse(response.body, symbolize_names: true)[:data]
   
        json.each do |contact| 
          expect(contact[:attributes]).to include(:first_name, :last_name, :company, :email, :phone_number, :notes, :user_id)
        end
      end

      it "should return 200 and an empty array if no contacts are found" do
        get api_v1_contacts_path, headers: { "Authorization" => "Bearer #{@token2}" }, as: :json

        expect(response).to be_successful
        json = JSON.parse(response.body, symbolize_names: true)
 
        expect(json[:data]).to eq([])
        expect(json[:message]).to eq("No contacts found")
      end
    end

    context "request is invalid" do 
      it "returns a 403 and an error message if no token is provided" do
        get api_v1_contacts_path, as: :json
  
        expect(response).to have_http_status(:unauthorized)
        json = JSON.parse(response.body, symbolize_names: true)
  
        expect(json[:error]).to eq("Not authenticated")
      end
  
      it "returns a 403 and an error message if an invalid token is provided" do
        get api_v1_contacts_path, headers: { "Authorization" => "Bearer invalid.token.here" }, as: :json
  
        expect(response).to have_http_status(:unauthorized)
        json = JSON.parse(response.body, symbolize_names: true)
  
        expect(json[:error]).to eq("Not authenticated")
      end
  
      it "returns a 403 and an error message if the token is expired" do
        user = User.create!(name: "Me", email: "its_me", password: "reallyGoodPass")
        expired_token = JWT.encode({ user_id: user.id, exp: 1.hour.ago.to_i }, Rails.application.secret_key_base, "HS256")
  
        get api_v1_contacts_path, headers: { "Authorization" => "Bearer #{expired_token}" }, as: :json
  
        expect(response).to have_http_status(:unauthorized)
        json = JSON.parse(response.body, symbolize_names: true)
  
        expect(json[:error]).to eq("Not authenticated")
      end

    end
  end
end