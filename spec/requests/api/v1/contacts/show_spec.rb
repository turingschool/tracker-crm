require "rails_helper"

describe "Contacts Controller", type: :request do
  describe "#show action" do
    context "Happy Paths" do
      before(:each) do
        @user = create(:user)
        @company = create(:company, user: @user)
        @contact = create(:contact, user: @user, company: @company)
        user_params = { email: @user.email, password: @user.password }
        post api_v1_sessions_path, params: user_params, as: :json
        @token = JSON.parse(response.body)["token"]
        
        @user2 = create(:user)
        user_params2 = { email: @user2.email, password: @user2.password }
        post api_v1_sessions_path, params: user_params2, as: :json
        @token2 = JSON.parse(response.body)["token"]
      end

      it "returns 200 and provides the appropriate contact details" do
        get api_v1_user_contact_path(@user.id, @contact.id), headers: { "Authorization" => "Bearer #{@token}" }, as: :json

        expect(response).to be_successful

        json = JSON.parse(response.body, symbolize_names: true)[:data]

        expect(json[:attributes][:first_name]).to eq(@contact.first_name)
        expect(json[:attributes][:last_name]).to eq(@contact.last_name)
        expect(json[:attributes][:email]).to eq(@contact.email)
        expect(json[:attributes][:phone_number]).to eq(@contact.phone_number)
        expect(json[:attributes][:notes]).to eq(@contact.notes)
        expect(json[:attributes][:company_id]).to eq(@company.id)
      end

      context "Sad Paths" do 
        it "returns a 403 and an error message if no token is provided" do
          get api_v1_user_contact_path(@user.id, @contact.id), as: :json
    
          expect(response).to have_http_status(:unauthorized)
          json = JSON.parse(response.body, symbolize_names: true)
    
          expect(json[:error]).to eq("Not authenticated")
        end
          
        it "returns a 403 and an error message if an invalid token is provided" do
          get api_v1_user_contact_path(@user.id, @contact.id), headers: { "Authorization" => "Bearer invalid.token.here" }, as: :json
    
          expect(response).to have_http_status(:unauthorized)
          json = JSON.parse(response.body, symbolize_names: true)
    
          expect(json[:error]).to eq("Not authenticated")
        end

        it "returns a 403 and an error message if the token is expired" do
          expired_token = JWT.encode({ user_id: @user.id, exp: 1.hour.ago.to_i }, Rails.application.secret_key_base, "HS256")
    
          get api_v1_user_contact_path(@user.id, @contact.id), headers: { "Authorization" => "Bearer #{expired_token}" }, as: :json
    
          expect(response).to have_http_status(:unauthorized)
          json = JSON.parse(response.body, symbolize_names: true)
    
          expect(json[:error]).to eq("Not authenticated")
        end

        it "returns a 400 and an error message if contact ID is not found" do
          get api_v1_user_contact_path(@user.id, id: 9999999999999999999), headers: { "Authorization" => "Bearer #{@token}" }, as: :json

          expect(response).not_to be_successful

          expect(response).to have_http_status(:not_found)
          json = JSON.parse(response.body, symbolize_names: true)

          expect(json[:message]).to include("Contact not found")
          expect(json[:status]).to eq(404)
          end

        it "returns a 400 and error message if user has no contacts" do
          get api_v1_user_contact_path(@user2.id, id: @contact.id), headers: { "Authorization" => "Bearer #{@token}" }, as: :json

          expect(response).not_to be_successful

          expect(response).to have_http_status(:not_found)
          json = JSON.parse(response.body, symbolize_names: true)

          expect(json[:message]).to include("Contact not found")
          expect(json[:status]).to eq(404)
        end
      end
    end
  end
end