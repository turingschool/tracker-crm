require "rails_helper"

describe "Sessions API", type: :request do
  describe "#create action (login)" do
    context "request is valid" do
      before(:each) do
        User.create(name: "Me", email: "its_me", password: "reallyGoodPass")
      end

      it "should return 200 and provide the appropriate data" do
        user_params = { email: "its_me", password: "reallyGoodPass" }

        post api_v1_sessions_path, params: user_params, as: :json
        json = JSON.parse(response.body, symbolize_names: true)
        expect(response).to have_http_status(:ok)
        expect(json).to have_key(:token)
        expect(json[:user][:data][:attributes]).to include(name: "Me", email: "its_me")
        expect(json[:user][:data][:attributes]).to_not have_key(:password)
      end
    end

    context "request is invalid" do
      it "should return error for bad credentials" do
        user_params = { email: "me@turing.edu", password: "diffPass" }

        post api_v1_sessions_path, params: user_params, as: :json
        json = JSON.parse(response.body, symbolize_names: true)

        expect(response).to have_http_status(:unauthorized)
        expect(json[:message]).to eq("Invalid login credentials")
        expect(json[:status]).to eq(401)
      end
    end
  end
end
