require "rails_helper"

RSpec.describe "Users Show", type: :request do
  describe "Get One User Endpoint" do
    let(:user) { create(:user) }

    before(:each) do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
    end

    it "returns a user by id" do
      get api_v1_user_path(user.id)

      expect(response).to be_successful
      json = JSON.parse(response.body, symbolize_names: true)

      expect(json[:data][:attributes][:name]).to eq(user.name)
      expect(json[:data][:attributes][:email]).to eq(user.email)
    end

    context "when accessing own profile" do
      it "returns the user's data" do
        user = create(:user)
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
    
        get api_v1_user_path(user)
    
        expect(response).to be_successful
        json = JSON.parse(response.body, symbolize_names: true)
        expect(json[:data][:id]).to eq(user.id.to_s)
      end
    end
    
    context "when accessing another user's profile" do
      it "returns unauthorized for non-admin users" do
        user = create(:user)
        other_user = create(:user)
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
    
        get api_v1_user_path(other_user)
    
        expect(response).to have_http_status(:unauthorized)
      end
    
      it "allows admin to view other users" do
        admin = create(:user, :admin)
        other_user = create(:user)
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin)
    
        get api_v1_user_path(other_user)
    
        expect(response).to be_successful
      end
    end
    
    it "returns not found for non-existent user" do
      admin = create(:user, :admin)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin)
    
      get api_v1_user_path(999999)
    
      expect(response).to have_http_status(:not_found)
    end
  end
end
