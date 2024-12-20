require "rails_helper"

RSpec.describe "Users Show", type: :request do
  describe "Get One User Endpoint" do
    let(:user) {User.create!(name: "Tom", email: "myspace_creator@email.com", password: "test123")}

    before(:each) do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
    end

    it "returns a user by id" do
      get api_v1_user_path(user.id)

      expect(response).to be_successful
      json = JSON.parse(response.body, symbolize_names: true)

      expect(json[:data][:attributes][:name]).to eq("Tom")
      expect(json[:data][:attributes][:email]).to eq("myspace_creator@email.com")
    end
  end
end
