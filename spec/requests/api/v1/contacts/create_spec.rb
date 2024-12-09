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

		it "creates a contact with only required fields" do
      minimal_params =  {first_name: "John", last_name: "Smith" }

      post api_v1_contacts_path, params: { contact: minimal_params }, headers: { "Authorization" => "Bearer #{@token}" }, as: :json

      expect(response).to have_http_status(:created)
      json = JSON.parse(response.body, symbolize_names: true)
      expect(json[:data][:attributes][:first_name]).to eq("John")
      expect(json[:data][:attributes][:last_name]).to eq("Smith")
    end

		it "should return an 422 error with missing required fields" do
			missing_contact_params = { first_name: "", last_name: "Smith" } 

			post api_v1_contacts_path, params: {contact: missing_contact_params}, headers: { "Authorization" => "Bearer #{@token}" }, as: :json

			expect(response).to have_http_status(:unprocessable_entity)
			json = JSON.parse(response.body, symbolize_names: true)
			
			expect(json[:error]).to eq("First name can't be blank")
		end

		it "creates a contact with only required fields" do
			minimal_params = { contact: { first_name: "John", last_name: "Smith" } }

			post api_v1_contacts_path, params: minimal_params, headers: { "Authorization" => "Bearer #{@token}" }, as: :json

			expect(response).to have_http_status(:created)
			json = JSON.parse(response.body, symbolize_names: true)
			expect(json[:data][:attributes][:first_name]).to eq("John")
			expect(json[:data][:attributes][:last_name]).to eq("Smith")
		end
	end
	
	context "edge cases" do
		it "returns an error if no token is provided" do
			contact_params = { contact: { first_name: "John", last_name: "Smith" } }

			post api_v1_contacts_path, params: contact_params, as: :json

			expect(response).to have_http_status(:unauthorized)
			json = JSON.parse(response.body, symbolize_names: true)
			expect(json[:error]).to eq("Not authenticated")
		end

		it "returns an error for invalid token" do
			contact_params = { contact: { first_name: "John", last_name: "Smith" } }

			post api_v1_contacts_path, params: contact_params, headers: { "Authorization" => "Bearer invalid.token" }, as: :json

			expect(response).to have_http_status(:unauthorized)
			json = JSON.parse(response.body, symbolize_names: true)
			expect(json[:error]).to eq("Not authenticated")
		end
	end
end

   
	
    #   it "should return a created contact if first and last name are present" do
    #     get api_v1_contacts_path, headers: { "Authorization" => "Bearer #{@token2}" }, as: :json

    #     expect(response).to be_successful
    #     json = JSON.parse(response.body, symbolize_names: true)
 
    #     expect(json[:data]).to eq([])
    #     expect(json[:message]).to eq("No contacts found")
    #   end
    # end

    # context "request is invalid" do 
    #   it "returns a 403 and an error message if no token is provided" do
    #     get api_v1_contacts_path, as: :json
  
    #     expect(response).to have_http_status(:unauthorized)
    #     json = JSON.parse(response.body, symbolize_names: true)
  
    #     expect(json[:error]).to eq("Not authenticated")
    #   end
  
    #   it "returns a 403 and an error message if an invalid token is provided" do
    #     get api_v1_contacts_path, headers: { "Authorization" => "Bearer invalid.token.here" }, as: :json
  
    #     expect(response).to have_http_status(:unauthorized)
    #     json = JSON.parse(response.body, symbolize_names: true)
  
    #     expect(json[:error]).to eq("Not authenticated")
    #   end
  
    #   it "returns a 403 and an error message if the token is expired" do
    #     user = User.create!(name: "Me", email: "its_me", password: "reallyGoodPass")
    #     expired_token = JWT.encode({ user_id: user.id, exp: 1.hour.ago.to_i }, Rails.application.secret_key_base, "HS256")
  
    #     get api_v1_contacts_path, headers: { "Authorization" => "Bearer #{expired_token}" }, as: :json
  
    #     expect(response).to have_http_status(:unauthorized)
    #     json = JSON.parse(response.body, symbolize_names: true)
  
    #     expect(json[:error]).to eq("Not authenticated")
    #   end

#     end
#   end
# end