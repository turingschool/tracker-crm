require "rails_helper"

describe "Contacts Controller", type: :request do
  describe "#destroy action" do
    context "Happy Paths" do
      before(:each) do
        @user = User.create!(name: "Me", email: "its_me", password: "reallyGoodPass")
        @company = Company.create!(name: "Turing", website: "www.turing.com", street_address: "123 Main St", city: "Denver", state: "CO", zip_code: "80218", user_id: @user.id)
        Contact.create!(first_name: "John", last_name: "Smith", company_id: @company.id, email: "123@example.com", phone_number: "123-555-6789", notes: "Notes here...", user_id: @user.id)
        user_params = { email: "its_me", password: "reallyGoodPass" }
        post api_v1_sessions_path, params: user_params, as: :json
        @token = JSON.parse(response.body)["token"]
      end

      it "should return 200 and delete the contact successfully" do
        expect(Contact.exists?(@contact.id)).to be_truthy

        delete api_v1_user_contacts_path(@user.id, @contact.id), headers: { "Authorization" => "Bearer #{@token}" }, as: :json  
        
        expect(response).to be_successful
        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body, symbolize_names: true)

        expect(json[:message]).to eq("Contact deleted successfully")
        expect(Contact.exists?(@contact.id)).to be_falsey
      end
    end

    context "Sad Paths" do
      before(:each) do
        @user = User.create!(name: "Me", email: "its_me", password: "reallyGoodPass")
        @contact = Contact.create!(first_name: "John", last_name: "Smith", email: "123@example.com", phone_number: "123-555-6789", user_id: @user.id)
        
        user_params = { email: "its_me", password: "reallyGoodPass" }
        post api_v1_sessions_path, params: user_params, as: :json
        @token = JSON.parse(response.body)["token"]
      end

      it "returns a 403 and an error message if no token is provided" do
        delete api_v1_user_contacts_path(@user.id, @contact.id), as: :json

        expect(response).to have_http_status(:unauthorized)
        json = JSON.parse(response.body, symbolize_names: true)

        expect(json[:error]).to eq("Not authenticated")
      end

      it "returns a 403 and an error message if an invalid token is provided" do
        delete api_v1_user_contacts_path(@user.id, @contact.id), headers: { "Authorization" => "Bearer invalid.token.here" }, as: :json

        expect(response).to have_http_status(:unauthorized)
        json = JSON.parse(response.body, symbolize_names: true)

        expect(json[:error]).to eq("Not authenticated")
      end

      it "returns a 404 and an error message if the contact ID does not exist" do
        delete api_v1_user_contacts_path(@user.id, 99999), headers: { "Authorization" => "Bearer #{@token}" }, as: :json

        expect(response).to have_http_status(:not_found)
        json = JSON.parse(response.body, symbolize_names: true)

        expect(json[:message]).to eq("Contact not found or unauthorized access")
      end

      it "returns a 403 and an error message if the user tries to delete another user's contact" do
        @user2 = User.create!(name: "Jane", email: "jane@example.com", password: "Password")
        @contact2 = Contact.create!(first_name: "Jane", last_name: "Doe", user_id: @user2.id)

        delete api_v1_user_contacts_path(@user.id, @contact2.id), headers: { "Authorization" => "Bearer #{@token}" }, as: :json

        expect(response).to have_http_status(:not_found)
        json = JSON.parse(response.body, symbolize_names: true)

        expect(json[:message]).to eq("Contact not found or unauthorized access")
      end
    end
  end
end
