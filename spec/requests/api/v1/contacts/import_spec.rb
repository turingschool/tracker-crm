require 'rails_helper'

describe "ImportContactsController", type: :request do
  describe "create - Happy Paths" do
    before(:each) do
      @user = create(:user)
      user_params = { email: @user.email, password: @user.password }
      post api_v1_sessions_path, params: user_params, as: :json
      @token = JSON.parse(response.body)["token"]
    end

    it "should return 201 and successfully imports multiple contacts" do
      contacts_to_import = {
        contacts: [
          {
            first_name: "Jacob",
            last_name: "Sample Boy",
            email: "sample@email.come",
            phone_number: "555-555-5555",
            notes: "Import trail blazer"
          },
          {
            first_name: "Beverly",
            last_name: "Also Help",
            email: "helper@email.com",
            phone_number: "123-456-7890",
            notes: "Front End Help"
          }
        ]
      }

      post import_api_v1_user_contacts_path(@user.id),
        params: contacts_to_import,
        headers: { "Authorization" => "Bearer #{@token}" },
        as: :json

      expect(response).to have_http_status(:created)
      json = JSON.parse(response.body, symbolize_names: true)

      puts JSON.pretty_generate(json)

      puts "JSON keys: #{json.keys}"

      expect(json[:imported]).to be_a(Hash)
      expect(json[:imported_count]).to eq(2)
      expect(json[:failed_count]).to eq(0)
      expect(json[:imported][:data].length).to eq(2)
      expect(json[:imported][:data][0][:attributes][:first_name]).to eq("Jacob")
    end

    it "imports contacts successfully with only required fields, first name and last name, and returns a 201" do
      contacts_to_import = {
        contacts: [
          {
            first_name: "Jacob",
            last_name: "Sample Boy"
          },
          {
            first_name: "Beverly",
            last_name: "Also Help"
          }
        ]
      }

      post import_api_v1_user_contacts_path(@user.id),
        params: contacts_to_import,
        headers: { "Authorization" => "Bearer #{@token}" },
        as: :json

      expect(response).to have_http_status(:created)
      json = JSON.parse(response.body, symbolize_names: true)
      expect(json[:imported_count]).to eq(1)
    end
  end

  describe "#import - Sad Paths" do
    it "returns 422 if there are missing required fields" do
      contacts_to_import = {
        contacts: [
          {
            first_name: "",
            last_name: "Sample Boy",
            email: "sample@email.come",
            phone_number: "555-555-5555",
            notes: "Import trail blazer"
          },
          {
            first_name: "Beverly",
            last_name: "",
            email: "helper@email.com",
            phone_number: "123-456-7890",
            notes: "Front End Help"
          }
        ]
      }

      post import_api_v1_user_contacts_path(@user.id),
        params: contacts_to_import,
        headers: { "Authorization" => "Bearer #{@token}" },
        as: :json

      expect(response).to have_http_status(:unprocessable_entity)
      json = JSON.parse(response.body, symbolize_names: true)
      expect(json[:message]).to include("Missing required fields")
    end

    it "returns 422 if the input is empty" do
      contacts_to_import = {
        contacts: []
      }

      post import_api_v1_user_contacts_path(@user.id),
        params: contacts_to_import,
        headers: { "Authorization" => "Bearer #{@token}" },
        as: :json

      expect(response).to have_http_status(:unprocessable_entity)
      json = JSON.parse(response.body, symbolize_names: true)
      expect(json[:message]).to include("No contacts to import")
    end
  end

  describe "#import - Edge Cases" do
    it "returns 401 when no auth token is provided" do
      contacts_to_import = {
        contacts: [
          {
            first_name: "Jacob",
            last_name: "Sample Boy",
            email: "sample@email.come",
            phone_number: "555-555-5555",
            notes: "Import trail blazer"
          },
          {
            first_name: "Beverly",
            last_name: "Also Help",
            email: "helper@email.com",
            phone_number: "123-456-7890",
            notes: "Front End Help"
          }
        ]
      }

      post import_api_v1_user_contacts_path(@user.id),
        params: contacts_to_import,
        as: :json

      expect(response).to have_http_status(:unauthorized)
      json = JSON.parse(response.body, symbolize_names: true)
      expect(json[:error]).to eq("not authenticated")
    end

    it "returns a 401 for an invalid token" do
      contacts_to_import = {
        contacts: [
          {
            first_name: "Jacob",
            last_name: "Sample Boy",
            email: "sample@email.come",
            phone_number: "555-555-5555",
            notes: "Import trail blazer"
          },
          {
            first_name: "Beverly",
            last_name: "Also Help",
            email: "helper@email.com",
            phone_number: "123-456-7890",
            notes: "Front End Help"
          }
        ]
      }

      post import_api_v1_user_contacts_path(@user.id),
        params: contacts_to_import,
        headers: { "Authorization" => "Bearer broken.token" },
        as: :json

      expect(response).to have_http_status(:unauthorized)
      json = JSON.parse(response.body, symbolize_names: true)
      expect(json[:error]).to eq("not authenticated")
    end
  end
end