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
      
      get "/api/v1/users/#{user.id}/companies/#{company.id}/contacts", headers: { "Authorization" => "Bearer #{@token}" }, as: :json
      
      expect(response).to have_http_status(:success)

      json = JSON.parse(response.body, symbolize_names: true)

      company = json[:company][:data]
      
      expect(company[:attributes][:name]).to eq("New Company")
      expect(company[:attributes][:website]).to eq("http://newcompany.com")
      expect(company[:attributes][:street_address]).to eq("123 Main St")
      expect(company[:attributes][:city]).to eq("New City")
      expect(company[:attributes][:state]).to eq("NY")
      expect(company[:attributes][:zip_code]).to eq("10001")
      expect(company[:attributes][:notes]).to eq("This is a new company.")
      
      contacts = json[:contacts][:data]
      expect(contacts).not_to be_nil

      contacts.each do |contact_data|
        contact = contact_data[:attributes]
        expect(contact[:first_name]).to eq("John").or eq("Jane")
        expect(contact[:last_name]).to eq("Doe").or eq("Smith")
        expect(contact[:email]).to eq("johndoe@email.com").or eq("janesmith@email.com")
        expect(contact[:phone_number]).to eq("123-456-7890").or eq("987-654-3210")
        expect(contact[:notes]).to eq("This is a contact.").or eq("This is another contact for the company.")
        expect(contact[:user_id]).to be_an(Integer)
      end
    end

    it 'should show an empty array if there are no contacts for that user company' do 
      company = Company.create!(user_id: user.id, name: "New Company", website: "http://newcompany.com", street_address: "123 Main St", city: "New City", state: "NY", zip_code: "10001", notes: "This is a new company.")

      get "/api/v1/users/#{user.id}/companies/#{company.id}/contacts", headers: { "Authorization" => "Bearer #{@token}" }, as: :json
      expect(response).to have_http_status(:success)

      json = JSON.parse(response.body, symbolize_names: true)

      expect(json[:contacts][:data]).to eq([])
    end

    it 'should only show the associated contacts to the company' do
      company = Company.create!(user_id: user.id, name: "New Company", website: "http://newcompany.com", street_address: "123 Main St", city: "New City", state: "NY", zip_code: "10001", notes: "This is a new company.")

      Contact.create!(first_name: "John", last_name: "Doe", company_id: company.id, email: "johndoe@email.com", phone_number: "123-456-7890", user_id: user.id, notes: "This is a contact.")

      Contact.create!(first_name: "Jane", last_name: "Smith", email: "janesmith@email.com", phone_number: "987-654-3210", user_id: user.id, notes: "This is another contact for the company.")

      get "/api/v1/users/#{user.id}/companies/#{company.id}/contacts", headers: { "Authorization" => "Bearer #{@token}" }, as: :json
      expect(response).to have_http_status(:success)

      json = JSON.parse(response.body, symbolize_names: true)

      contacts = json[:contacts][:data]
      expect(contacts).not_to be_nil
      
      expect(contacts.length).to eq(1)

      contacts.each do |contact_data|
        contact = contact_data[:attributes]
        expect(contact[:first_name]).to eq("John")
        expect(contact[:last_name]).to eq("Doe")
        expect(contact[:email]).to eq("johndoe@email.com")
        expect(contact[:phone_number]).to eq("123-456-7890")
        expect(contact[:notes]).to eq("This is a contact.")
        expect(contact[:user_id]).to be_an(Integer)
      end
    end

    it 'should return a 404 error if the company does not exist' do
      get "/api/v1/users/#{user.id}/companies/9999/contacts", headers: { "Authorization" => "Bearer #{@token}" }, as: :json
    
      expect(response).to have_http_status(:not_found)
    
      json = JSON.parse(response.body, symbolize_names: true)
      expect(json[:message]).to include("Company not found")
      expect(json[:status]).to eq(404)
    end
  end
end