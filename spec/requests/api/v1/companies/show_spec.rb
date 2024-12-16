require "rails_helper"

describe "Companies API", type: :request do
  describe "Show#action" do 
    let!(:user){ User.create!(name: "Melchor", email: "melchor@example.com", password: "password123") }
  
    before do
      post api_v1_sessions_path, params: { email: user.email, password: "password123" }, as: :json
      @token = JSON.parse(response.body)["token"]
    end
  
    it "should be able to show a company if user is logged in and associated contacts" do
      
      company = Company.create!(user_id: user.id, name: "New Company", website: "http://newcompany.com", street_address: "123 Main St", city: "New City", state: "NY", zip_code: "10001", notes: "This is a new company.")

      Contact.create!(first_name: "John", last_name: "Doe", company_id: company.id, email: "johndoe@email.com", phone_number: "123-456-7890", user_id: user.id, notes: "This is a contact.")

      Contact.create!(first_name: "Jane", last_name: "Smith", company_id: company.id, email: "janesmith@email.com", phone_number: "987-654-3210", user_id: user.id, notes: "This is another contact for the company."
)

      get "/api/v1/users/#{user.id}/companies/#{company.id}", headers: { "Authorization" => "Bearer #{@token}" }, as: :json

      expect(response).to have_http_status(:success)

      json = JSON.parse(response.body, symbolize_names: true)

      expect(json[:data][:id]).to eq(company.id.to_s)
      expect(json[:data][:type]).to eq("company")
      expect(json[:data][:attributes][:name]).to eq(company.name)
      expect(json[:data][:attributes][:website]).to eq(company.website)
      expect(json[:data][:attributes][:street_address]).to eq(company.street_address)
      expect(json[:data][:attributes][:city]).to eq(company.city)
      expect(json[:data][:attributes][:state]).to eq(company.state)
      expect(json[:data][:attributes][:zip_code]).to eq(company.zip_code)
      expect(json[:data][:attributes][:notes]).to eq(company.notes)
      expect(json[:data][:attributes][:contacts].count).to eq(2)
      json[:data][:attributes][:contacts].each do |contact|
        expect(contact[:first_name]).to eq("John").or eq("Jane")
        expect(contact[:last_name]).to eq("Doe").or eq("Smith")
        expect(contact[:email]).to eq("johndoe@email.com").or eq("janesmith@email.com")
        expect(contact[:phone_number]).to eq("123-456-7890").or eq("987-654-3210")
        expect(contact[:notes]).to eq("This is a contact.").or eq("This is another contact for the company.")
      end
    end
  end
end