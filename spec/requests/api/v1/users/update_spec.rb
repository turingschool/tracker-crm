require "rails_helper"

RSpec.describe "Users Update", type: :request do
  describe "Update User Endpoint" do
    let(:user) do
        User.create!(name:"MeanGirl", email:"anemail", password:"1234321", password_confirmation:"1234321")
    end
    let(:user_params) do
      {
        id: user.id,
        name: "Me",
        email: "its_me",
        password: "QWERTY123",
        password_confirmation: "QWERTY123"
      }
    end

    context "request is valid" do
      it "returns 200 Okay and provides expected fields" do
        put api_v1_user_path(user.id), params: user_params, as: :json

        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body, symbolize_names: true)
        expect(json[:data][:type]).to eq("user")
        expect(json[:data][:id]).to eq(user.id.to_s)
        expect(json[:data][:attributes][:name]).to eq(user_params[:name])
        expect(json[:data][:attributes][:email]).to eq(user_params[:email])
        expect(json[:data][:attributes]).to_not have_key(:password)
        expect(json[:data][:attributes]).to_not have_key(:password_confirmation)
      end
    end

    context "request is invalid" do
      it "returns an error for non-unique email" do
        User.create!(name: "me", email: "its_me", password: "abc123")

        put api_v1_user_path(user.id), params: user_params, as: :json
        json = JSON.parse(response.body, symbolize_names: true)

        expect(response).to have_http_status(:bad_request)
        expect(json[:message]).to eq("Email has already been taken")
        expect(json[:status]).to eq(400)
      end

      it "returns an error when password does not match password confirmation" do
        user_params = {
          name: "me",
          email: "its_me",
          password: "QWERTY123",
          password_confirmation: "QWERT123"
        }

        put api_v1_user_path(user.id), params: user_params, as: :json
        json = JSON.parse(response.body, symbolize_names: true)

        expect(response).to have_http_status(:bad_request)
        expect(json[:message]).to eq("Password confirmation doesn't match Password")
        expect(json[:status]).to eq(400)
      end

      it "returns an error for missing field" do
        user_params[:email] = ""

        put api_v1_user_path(user.id), params: user_params, as: :json
        json = JSON.parse(response.body, symbolize_names: true)

        expect(response).to have_http_status(:bad_request)
        expect(json[:message]).to eq("Email can't be blank")
        expect(json[:status]).to eq(400)
      end
    end
  end
end