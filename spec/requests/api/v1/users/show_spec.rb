require "rails_helper"

RSpec.describe "Users Show", type: :request do
  describe "Get One User Endpoint" do
    it "returns a user by id" do
      User.create!(name: "Tom", email: "myspace_creator@email.com", password: "test123")

      get api_v1_user_path(User.last.id)

      expect(response).to be_successful
      json = JSON.parse(response.body, symbolize_names: true)

      expect(json[:data][:attributes][:name]).to eq("Tom")
      expect(json[:data][:attributes][:email]).to eq("myspace_creator@email.com")
    end
  end
end
