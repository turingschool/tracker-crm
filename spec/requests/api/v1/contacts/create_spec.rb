require "rails_helper"

describe "Contacts Create", type: :request do
  describe "#Create Contact Endpoint" do
		before(:each) do
			@user1 = User.create!(name: "Me", email: "happy@gmail.com", password: "reallyGoodPass")
			user_params = { email: "happy@gmail.com", password: "reallyGoodPass" }
			post api_v1_sessions_path, params: user_params, as: :json
			@token = JSON.parse(response.body)["token"]
			
			@user2 = User.create!(name: "Jane", email: "dancing@gmail.com", password: "Password")
			user_params2 = { email: "dancing", password: "Password" }
			post api_v1_sessions_path, params: user_params2, as: :json
			@token2 = JSON.parse(response.body)["token"]

			@company = Company.create!(
				name: "Turing", 
				website: "www.turing.com", 
				street_address: "123 Main St",
				city: "Denver",
				state: "CO",
				zip_code: "80218",
				user_id: @user1.id)
		end

		it "should return 201 and create a contact with valid fields" do
			contact_params = {
				contact: {
					first_name: "John",
					last_name: "Smith",
					company_id: @company.id,
					email: "john@example.com",
					phone_number: "123-555-6789",
					notes: "Notes here..."
				}
			}

			post api_v1_contacts_path, params: contact_params, headers: { "Authorization" => "Bearer #{@token}" }, as: :json

			expect(response).to have_http_status(:created)
			json = JSON.parse(response.body, symbolize_names: true)[:data]
			expect(json[:attributes][:first_name]).to eq("John")
			expect(json[:attributes][:last_name]).to eq("Smith")
			expect(json[:attributes][:email]).to eq("john@example.com")
			expect(json[:attributes][:phone_number]).to eq("123-555-6789")
			expect(json[:attributes][:notes]).to eq("Notes here...")
			expect(json[:attributes][:company_id]).to eq(@company.id)
		end

		it "creates a contact with only required fields, first and last name, and returns a 201" do
      minimal_params =  { contact: {first_name: "John", last_name: "Smith" } }

      post api_v1_contacts_path, params: minimal_params , headers: { "Authorization" => "Bearer #{@token}" }, as: :json

      expect(response).to have_http_status(:created)
      json = JSON.parse(response.body, symbolize_names: true)[:data]
      expect(json[:attributes][:first_name]).to eq("John")
      expect(json[:attributes][:last_name]).to eq("Smith")
    end

		it 'creates a contact with a correct email, and returns a 201' do
			partial_params =  { contact: {first_name: "John", last_name: "Smith", email: "john@example.com"} }

      post api_v1_contacts_path, params: partial_params , headers: { "Authorization" => "Bearer #{@token}" }, as: :json

      expect(response).to have_http_status(:created)
      json = JSON.parse(response.body, symbolize_names: true)[:data]
      expect(json[:attributes][:first_name]).to eq("John")
      expect(json[:attributes][:last_name]).to eq("Smith")
			expect(json[:attributes][:email]).to eq("john@example.com")
		end

		it 'creates a contact with a valid phone number, returns a 201' do
			partial_params =  { contact: {first_name: "John", last_name: "Smith", phone_number: "123-555-6789"} }

      post api_v1_contacts_path, params: partial_params , headers: { "Authorization" => "Bearer #{@token}" }, as: :json

      expect(response).to have_http_status(:created)
      json = JSON.parse(response.body, symbolize_names: true)[:data]
      expect(json[:attributes][:first_name]).to eq("John")
      expect(json[:attributes][:last_name]).to eq("Smith")
			expect(json[:attributes][:phone_number]).to eq("123-555-6789")
		end
	end
	
	context "when the request is invalid" do
		before(:each) do
			@user1 = User.create!(name: "Me", email: "happy@gmail.com", password: "reallyGoodPass")
			user_params = { email: "happy@gmail.com", password: "reallyGoodPass" }
			post api_v1_sessions_path, params: user_params, as: :json
			@token = JSON.parse(response.body)["token"]
			
			@user2 = User.create!(name: "Jane", email: "dancing@gmail.com", password: "Password")
			user_params2 = { email: "dancing", password: "Password" }
			post api_v1_sessions_path, params: user_params2, as: :json
			@token2 = JSON.parse(response.body)["token"]

			@company = Company.create!(
				name: "Turing", 
				website: "www.turing.com", 
				street_address: "123 Main St",
				city: "Denver",
				state: "CO",
				zip_code: "80218",
				user_id: @user1.id)
		end

		it "returns a 422 error when creating a duplicate contact" do
      minimal_params =  { contact: {first_name: "John", last_name: "Smith" } }
      post api_v1_contacts_path, params: minimal_params , headers: { "Authorization" => "Bearer #{@token}" }, as: :json

      expect(response).to have_http_status(:created)
			expect(response).to be_successful

      post api_v1_contacts_path, params: minimal_params , headers: { "Authorization" => "Bearer #{@token}" }, as: :json
			expect(response).to_not be_successful
			expect(response).to have_http_status(:unprocessable_entity)

      json = JSON.parse(response.body, symbolize_names: true)
      expect(json[:error]).to eq("First name and Last name already exist for this user")
    end

		it "returns a 422 error for missing first_name" do
			missing_contact_params = { contact: { first_name: "", last_name: "Smith" } }

			post api_v1_contacts_path, params: missing_contact_params, headers: { "Authorization" => "Bearer #{@token}" }, as: :json

			expect(response).to have_http_status(:unprocessable_entity)
			json = JSON.parse(response.body, symbolize_names: true)
			expect(json[:error]).to eq("First name can't be blank")
		end

		it "returns a 422 error for missing last_name" do
			missing_contact_params = { contact: { first_name: "John", last_name: "" } }

			post api_v1_contacts_path, params: missing_contact_params, headers: { "Authorization" => "Bearer #{@token}" }, as: :json

			expect(response).to have_http_status(:unprocessable_entity)
			json = JSON.parse(response.body, symbolize_names: true)
			expect(json[:error]).to eq("Last name can't be blank")
		end

		it "returns a 422 error for invalid email format" do
			invalid_email_params = { contact: { first_name: "John", last_name: "Smith", email: "invalid-email" } }

			post api_v1_contacts_path, params: invalid_email_params, headers: { "Authorization" => "Bearer #{@token}" }, as: :json

			expect(response).to have_http_status(:unprocessable_entity)
			json = JSON.parse(response.body, symbolize_names: true)
			expect(json[:error]).to eq("Email must be a valid email address")
		end

		it "returns a 422 error for an invalid phone number format" do
			invalid_phone_params = { contact: { first_name: "John", last_name: "Smith", phone_number: "555555555" } }

			post api_v1_contacts_path, params: invalid_phone_params, headers: { "Authorization" => "Bearer #{@token}" }, as: :json

			expect(response).to have_http_status(:unprocessable_entity)
			json = JSON.parse(response.body, symbolize_names: true)
			expect(json[:error]).to eq("Phone number must be in the format '555-555-5555'")
		end
	end

	context "edge cases" do
		it "returns a 401 error if no token is provided" do
			contact_params = { contact: { first_name: "John", last_name: "Smith" } }

			post api_v1_contacts_path, params: contact_params, as: :json

			expect(response).to have_http_status(:unauthorized)
			json = JSON.parse(response.body, symbolize_names: true)
			expect(json[:error]).to eq("Not authenticated")
		end

		it "returns a 401 error for invalid token" do
			contact_params = { contact: { first_name: "John", last_name: "Smith" } }

			post api_v1_contacts_path, params: contact_params, headers: { "Authorization" => "Bearer invalid.token" }, as: :json

			expect(response).to have_http_status(:unauthorized)
			json = JSON.parse(response.body, symbolize_names: true)
			expect(json[:error]).to eq("Not authenticated")
		end
	end
end
