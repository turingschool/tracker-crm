require "rails_helper"

describe "Contacts Controller", type: :request do
  describe "#destroy action" do
    context "Happy Paths" do
      before(:each) do
        @user = create(:user)
        @company = create(:company, user: @user)
        @contact = create(:contact, user: @user)
        user_params = { email: @user.email, password: @user.password }
        post api_v1_sessions_path, params: user_params, as: :json
        @token = JSON.parse(response.body)["token"]
      end

      it "should return 200 and delete the contact successfully" do
        expect(Contact.exists?(@contact.id)).to be_truthy

        delete api_v1_user_contact_path(@user.id, @contact.id), headers: { "Authorization" => "Bearer #{@token}" }, as: :json  
        
        expect(response).to be_successful
        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body, symbolize_names: true)

        expect(json[:message]).to eq("Contact deleted successfully")
        expect(Contact.exists?(@contact.id)).to be_falsey
      end
    end

    context "Sad Paths" do
      before(:each) do
        @user = create(:user)
        @contact = create(:contact, user: @user)
        
        user_params = { email: @user.email, password: @user.password }
        post api_v1_sessions_path, params: user_params, as: :json
        @token = JSON.parse(response.body)["token"]
      end

      it "returns a 401 and an error message if no token is provided" do
        delete api_v1_user_contact_path(@user.id, @contact.id), as: :json

        expect(response).to have_http_status(:unauthorized)
        json = JSON.parse(response.body, symbolize_names: true)

        expect(json[:error]).to eq("Not authenticated")
      end

      it "returns a 401 and an error message if an invalid token is provided" do
        delete api_v1_user_contact_path(@user.id, @contact.id), headers: { "Authorization" => "Bearer invalid.token.here" }, as: :json

        expect(response).to have_http_status(:unauthorized)
        json = JSON.parse(response.body, symbolize_names: true)

        expect(json[:error]).to eq("Not authenticated")
      end

      it "returns a 404 and an error message if the contact ID does not exist" do
        delete api_v1_user_contact_path(@user.id, 99999), headers: { "Authorization" => "Bearer #{@token}" }, as: :json

        expect(response).to have_http_status(:not_found)

        json = JSON.parse(response.body, symbolize_names: true)

        expect(json[:message]).to eq("Contact not found or unauthorized access")
        expect(json[:status]).to eq(404)
      end

      it "returns a 401 and an error message if the user tries to delete another user's contact" do
        @user2 = User.create!(name: "Jane", email: "jane@example.com", password: "Password")
        @contact2 = create(:contact, user_id: @user2.id)

        delete api_v1_user_contact_path(@user.id, @contact2.id), headers: { "Authorization" => "Bearer #{@token}" }, as: :json

        expect(response).to have_http_status(:not_found)
        json = JSON.parse(response.body, symbolize_names: true)

        expect(json[:message]).to eq("Contact not found or unauthorized access")
        expect(json[:status]).to eq(404)
      end
    end
  end
end
