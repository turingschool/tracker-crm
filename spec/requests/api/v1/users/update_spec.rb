require "rails_helper"

RSpec.describe "Users Update", type: :request do
  describe "Update User Endpoint" do
    let(:user) { create(:user) }
    let(:update_params) { { 
      email: "new_email@example.com", 
      password: "newpassword123", 
      password_confirmation: "newpassword123" 
    } }
    
    before(:each) do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
    end

    context "request is valid" do
      it "returns 200 Okay and provides expected fields" do
        put api_v1_user_path(user.id), params: update_params, as: :json

        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body, symbolize_names: true)
        expect(json[:data][:type]).to eq("user")
        expect(json[:data][:id]).to eq(user.id.to_s)
        expect(json[:data][:attributes][:email]).to eq(update_params[:email])
        expect(json[:data][:attributes]).to_not have_key(:password)
        expect(json[:data][:attributes]).to_not have_key(:password_confirmation)
      end
    end

    context "request is invalid" do
      it "returns an error for non-unique email" do
        existing_user = create(:user, email: "taken@email.com")
        invalid_params = { 
          email: existing_user.email,
          password: "newpassword123",
          password_confirmation: "newpassword123"
        }

        put api_v1_user_path(user.id), params: invalid_params, as: :json
        json = JSON.parse(response.body, symbolize_names: true)

        expect(response).to have_http_status(:bad_request)
        expect(json[:message]).to eq("Email has already been taken")
        expect(json[:status]).to eq(400)
      end

      it "returns an error when password does not match password confirmation" do
        invalid_params = { 
          password: "newpassword123",
          password_confirmation: "different_password"
        }

        put api_v1_user_path(user.id), params: invalid_params, as: :json
        json = JSON.parse(response.body, symbolize_names: true)

        expect(response).to have_http_status(:bad_request)
        expect(json[:message]).to eq("Password confirmation doesn't match Password")
        expect(json[:status]).to eq(400)
      end

      it "returns an error for missing field" do
        invalid_params = { email: "" }

        put api_v1_user_path(user.id), params: invalid_params, as: :json
        json = JSON.parse(response.body, symbolize_names: true)

        expect(response).to have_http_status(:bad_request)
        expect(json[:message]).to eq("Email can't be blank and Password can't be blank")
        expect(json[:status]).to eq(400)
      end
    end
  end
end