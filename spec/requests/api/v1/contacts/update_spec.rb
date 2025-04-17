require "rails_helper"

describe "Contacts Controller", type: :request do
  describe "#update action" do
    context "Happy Paths" do
      before(:each) do
        @user = create(:user)
        @company = create(:company, user: @user)
        @contact = create(:contact, user: @user, company: @company)
        
        user_params = { email: @user.email, password: @user.password }
        post api_v1_sessions_path, params: user_params, as: :json
        @token = JSON.parse(response.body)["token"]
      end

      it "should return 200 and update a contact" do
        update_params = { contact: { email: "updated@example.com", phone_number: "555-555-5556", notes: "Updated notes" } }

        patch api_v1_user_contact_path(@user.id, @contact.id), 
              headers: { "Authorization" => "Bearer #{@token}" }, 
              params: update_params, 
              as: :json

        expect(response).to be_successful
        json = JSON.parse(response.body, symbolize_names: true)[:data][:attributes]

        expect(json[:email]).to eq("updated@example.com")
        expect(json[:phone_number]).to eq("555-555-5556")
        expect(json[:notes]).to eq("Updated notes")
      end
    end

    context "Sad Paths" do
      before(:each) do
        @user = create(:user)
        @company = create(:company, user: @user)
        @contact = create(:contact, user: @user, company: @company)
        
        user_params = { email: @user.email, password: @user.password }
        post api_v1_sessions_path, params: user_params, as: :json
        @token = JSON.parse(response.body)["token"]
      end

      it "returns a 404 if contact does not exist" do
        patch api_v1_user_contact_path(@user.id, 99999), 
              headers: { "Authorization" => "Bearer #{@token}" }, 
              params: { contact: { email: "new_email@example.com" } }, 
              as: :json
      
        expect(response).to have_http_status(:not_found)
        
        json = JSON.parse(response.body, symbolize_names: true)
  
        expect(json[:message]).to eq("Contact not found")
      end
      
      it "returns a 422 if validation fails (invalid phone number format)" do
        patch api_v1_user_contact_path(@user.id, @contact.id), 
              headers: { "Authorization" => "Bearer #{@token}" }, 
              params: { contact: { phone_number: "invalid-number" } }, 
              as: :json
      
        expect(response).to have_http_status(:unprocessable_entity)
        json = JSON.parse(response.body, symbolize_names: true)
      
        expect(json[:message]).to include("Phone number must be in the format '555-555-5555'")
        expect(json[:status]).to eq(422)
      end
      
    end
  end
end
