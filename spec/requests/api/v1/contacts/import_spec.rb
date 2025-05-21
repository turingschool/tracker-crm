require 'rails_helper'

describe "ImportContactsController", type: :request do
  describe "create - Happy Paths" do
    before(:each) do
      @user = create(:user)
      post apv_v1_sessions_path, params: { email: @user.email, password: @user.password }, as: :json
      @token = JSON.parse(response.body)["token"]
    end

    it "should return 201 and successfully imports multiple contacts" do
      csv_to_import = {
        file: fixture_file_upload("files/valid_contacts.csv", "text/csv") #these files still need to be created, I just want to ensure I test csv data
      }

      post import_api_v1_user_contacts_path(@user.id),
        params: csv_to_import,
        headers: { "Authorization" => "Bearer #{@token}" }

      expect(response).to have_http_status(:created)
      expect(Contact.count).to eq(2)
    end

    it "imports contacts successfully with only required fields, first name and last name, and returns a 201" do
      csv_to_import = {
        file: fixture_file_upload("files/only_required_fields_contacts.csv", "text/csv") #these files still need to be created, I just want to ensure I test csv data
      }

      post import_api_v1_user_contacts_path(@user.id),
        params: csv_to_import,
        headers: { "Authorization" => "Bearer #{@token}" }

      expect(response).to have_http_status(:created)
      expect(Contact.count).to eq(1)
      expect(Contact.last.first_name).to be_present
      expect(Contact.last.last_name).to be_present
    end
  end

  describe "#import - Sad Paths" do
    it "returns 422 if the CSV is missing required fields" do
      csv_to_import = {
          file: fixture_file_upload("files/invalid_missing_names.csv", "text/csv") #these files still need to be created, I just want to ensure I test csv data
        }

      post import_api_v1_user_contacts_path(@user.id),
        params: csv_to_import,
        headers: { "Authorization" => "Bearer #{@token}" }

        
      expect(response).to have_http_status(:unprocessable_entity)
      json = JSON.parse(response.body, symbolize_names: true)
      expect(json[:message]).to include("Missing required fields")
    end

    it "returns 422 if the CSV file is empty" do
      csv_to_import = {
          file: fixture_file_upload("files/empty.csv", "text/csv") #these files still need to be created, I just want to ensure I test csv data
        }

      post import_api_v1_user_contacts_path(@user.id),
        params: csv_to_import,
        headers: { "Authorization" => "Bearer #{@token}" }

        
      expect(response).to have_http_status(:unprocessable_entity)
      json = JSON.parse(response.body, symbolize_names: true)
      expect(json[:message]).to include("No contacts to import")
    end
  end

  describe "#import - Edge Cases" do
    it "returns 401 when no auth token is provided" do
      csv_to_import = {
          file: fixture_file_upload("files/valid_contacts.csv", "text/csv") #these files still need to be created, I just want to ensure I test csv data
        }

      post import_api_v1_user_contacts_path(@user.id), params: csv_to_import

      expect(response).to have_http_status(:unauthorized)
      json = JSON.parse(response.body, symbolize_names: true)
      expect(json[:error]).to eq("Not authenticated")
    end

    it "returns a 401 for an invalid token" do
      csv_to_import = {
          file: fixture_file_upload("files/valid_contacts.csv", "text/csv") #these files still need to be created, I just want to ensure I test csv data
        }

      post import_api_v1_user_contacts_path(@user.id), 
        params: csv_to_import,
        headers: { "Authorization" => "Bearer broken.token"}

      expect(response).to have_http_status(:unauthorized)
    end
  end
end