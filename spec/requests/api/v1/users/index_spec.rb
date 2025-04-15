require "rails_helper"

RSpec.describe "Users Index", type: :request do
  describe "Get All Users Endpoint" do
    context "when user is admin" do
      let(:admin) { create(:user, :admin) }

      before(:each) do
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin)
      end

      it "retrieves all users but does not share any sensitive data" do
        create(:user)
        create(:user)
        create(:user)

        get api_v1_users_path

        expect(response).to be_successful
        json = JSON.parse(response.body, symbolize_names: true)

        expect(json[:data].count).to eq(4)
        expect(json[:data][0][:attributes]).to have_key(:name)
        expect(json[:data][0][:attributes]).to have_key(:email)
        expect(json[:data][0][:attributes]).to_not have_key(:password)
        expect(json[:data][0][:attributes]).to_not have_key(:password_digest)
      end
    end

    context "when user is not admin" do
      it "returns unauthorized when regular user tries to access" do
        user = create(:user)
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

        get api_v1_users_path

        expect(response).to have_http_status(:unauthorized)
        json = JSON.parse(response.body, symbolize_names: true)
        expect(json[:message]).to eq("You are not authorized to perform this action")
        expect(json[:status]).to eq(401)
      end

      it "returns unauthorized when no user is logged in" do
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(nil)

        get api_v1_users_path

        expect(response).to have_http_status(:unauthorized)
        json = JSON.parse(response.body, symbolize_names: true)
        expect(json[:message]).to eq("You are not authorized to perform this action")
        expect(json[:status]).to eq(401)
      end
    end
  end
end