require "rails_helper"

describe "Companies API", type: :request do
  describe "Create#action" do 
    it "should be able to create a new company if user is logged in" do
      user = User.create!(name: "Melchor", email: "melchor@email.com", password: "test123")
      company_params = {
        name: "Turing",
        website: "www.company.com",
        street_address: "123streetaddress",
        city: "Company City",
        state: "Company State",
        zip_code: "12345",
        notes: "Thsi is a company",
        user_id: user
      }
      post "api/v1/users/#{user.id}/companies", params: company_params

      expect(response).to be_successful
    end
  end
end