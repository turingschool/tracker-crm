require "rails_helper"

RSpec.describe "Users Index", type: :request do
  describe "Get All Users Endpoint" do
    it "retrieves all users but does not share any sensitive data" do
      User.create!(name: "Tom", email: "myspace_creator@email.com", password: "test123")
      User.create!(name: "Oprah", email: "oprah@email.com", password: "abcqwerty")
      User.create!(name: "Beyonce", email: "sasha_fierce@email.com", password: "blueivy")

      get api_v1_users_path

      expect(response).to be_successful
      json = JSON.parse(response.body, symbolize_names: true)

      expect(json[:data].count).to eq(3)
      expect(json[:data][0][:attributes]).to have_key(:name)
      expect(json[:data][0][:attributes]).to have_key(:email)
      expect(json[:data][0][:attributes]).to_not have_key(:password)
      expect(json[:data][0][:attributes]).to_not have_key(:password_digest)
    end
  end
end