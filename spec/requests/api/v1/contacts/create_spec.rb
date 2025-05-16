require "rails_helper"

describe "Contacts Controller", type: :request do
  describe "#create action - Happy Paths" do
		before(:each) do
			@user1 = create(:user)
			user_params = { email: @user1.email, password: @user1.password }
			post api_v1_sessions_path, params: user_params, as: :json
			@token = JSON.parse(response.body)["token"]
			
			@user2 = create(:user)
			user_params2 = { email: @user2.email, password: @user2.password }
			post api_v1_sessions_path, params: user_params2, as: :json
			@token2 = JSON.parse(response.body)["token"]

			@company = create(:company, user: @user1)
		end

		it "should return 201 and create a contact with valid fields" do
			contact_params = {
				contact: {
					first_name: Faker::Name.first_name,
					last_name: Faker::Name.last_name,
					company_id: @company.id,
					email: Faker::Internet.email,
					phone_number: "505-321-9595",
					notes: Faker::Lorem.sentence
				}
			}

			post api_v1_user_contacts_path(@user1.id), params: contact_params, headers: { "Authorization" => "Bearer #{@token}" }, as: :json

			expect(response).to have_http_status(:created)
			json = JSON.parse(response.body, symbolize_names: true)[:data]
			expect(json[:attributes][:first_name]).to eq(contact_params[:contact][:first_name])
			expect(json[:attributes][:last_name]).to eq(contact_params[:contact][:last_name])
			expect(json[:attributes][:email]).to eq(contact_params[:contact][:email])
			expect(json[:attributes][:phone_number]).to eq(contact_params[:contact][:phone_number])
			expect(json[:attributes][:notes]).to eq(contact_params[:contact][:notes])
			expect(json[:attributes][:company_id]).to eq(@company.id)
		end

		it "creates a contact with only required fields, first and last name, and returns a 201" do
      minimal_params =  { contact: {first_name: Faker::Name.first_name, last_name: Faker::Name.last_name } }

      post api_v1_user_contacts_path(@user1.id), params: minimal_params , headers: { "Authorization" => "Bearer #{@token}" }, as: :json

      expect(response).to have_http_status(:created)
      json = JSON.parse(response.body, symbolize_names: true)[:data]
      expect(json[:attributes][:first_name]).to eq(minimal_params[:contact][:first_name])
      expect(json[:attributes][:last_name]).to eq(minimal_params[:contact][:last_name])
    end

		it 'creates a contact with a correct email, and returns a 201' do
			partial_params =  { contact: {first_name: Faker::Name.first_name, last_name: Faker::Name.last_name, email: Faker::Internet.email} }

      post api_v1_user_contacts_path(@user1.id), params: partial_params , headers: { "Authorization" => "Bearer #{@token}" }, as: :json

      expect(response).to have_http_status(:created)
      json = JSON.parse(response.body, symbolize_names: true)[:data]
      expect(json[:attributes][:first_name]).to eq(partial_params[:contact][:first_name])
      expect(json[:attributes][:last_name]).to eq(partial_params[:contact][:last_name])
			expect(json[:attributes][:email]).to eq(partial_params[:contact][:email])
		end

		it 'creates a contact with a valid phone number, returns a 201' do
			partial_params =  { contact: {first_name: Faker::Name.first_name, last_name: Faker::Name.last_name, phone_number: "112-432-8883"} }

      post api_v1_user_contacts_path(@user1.id), params: partial_params , headers: { "Authorization" => "Bearer #{@token}" }, as: :json

      expect(response).to have_http_status(:created)
      json = JSON.parse(response.body, symbolize_names: true)[:data]
      expect(json[:attributes][:first_name]).to eq(partial_params[:contact][:first_name])
      expect(json[:attributes][:last_name]).to eq(partial_params[:contact][:last_name])
			expect(json[:attributes][:phone_number]).to eq(partial_params[:contact][:phone_number])
		end

		it 'creates a contact when given the company ID, returns a 201' do
			minimal_params =  { contact: {first_name: Faker::Name.first_name, last_name: Faker::Name.last_name } }
			post api_v1_user_company_contacts_path(user_id: @user1.id, company_id: @company.id), params: minimal_params , headers: { "Authorization" => "Bearer #{@token}" }, as: :json
			
			expect(response).to have_http_status(:created)
			json = JSON.parse(response.body, symbolize_names: true)[:data]
			
			expect(json[:attributes][:first_name]).to eq(minimal_params[:contact][:first_name])
			expect(json[:attributes][:last_name]).to eq(minimal_params[:contact][:last_name])
			expect(json[:attributes][:company][:name]).to eq(@company.name)
		end

		it 'creates contact and assigns it to a job application if jobApplicationId params is present ' do 
			job_application = JobApplication.create!(
				position_title: "Jr. CTO",
				date_applied: "2024-10-31",
				status: :submitted,
				notes: "Fingers crossed!",
				job_description: "Looking for Turing grad/jr dev to be CTO",
				application_url: "www.example1.com",
				company: @company,
				user: @user1,
    	)

			contact_params = {
				contact: {
					first_name: "John",
					last_name: "Smith",
					company_id: @company.id,
					email: "john@example.com",
					phone_number: "123-555-6789",
					notes: "Notes here...",
				},
				job_application_id: job_application.id
			}

			post api_v1_user_contacts_path(@user1.id), params: contact_params , headers: { "Authorization" => "Bearer #{@token}" }, as: :json

			expect(response).to have_http_status(:created)
			json = JSON.parse(response.body, symbolize_names: true)[:data]
			updated_contact_id = json[:id].to_i

			expect(job_application.reload.contact_id).to eq(updated_contact_id)
		end

		it 'will not assign a contact to a job application that belongs to another user' do
		  job_application = JobApplication.create!(
				position_title: "Jr. CTO",
				date_applied: "2024-10-31",
				status: :submitted,
				notes: "Fingers crossed!",
				job_description: "Looking for Turing grad/jr dev to be CTO",
				application_url: "www.example1.com",
				company: @company,
				user: @user2,
    	)

			contact_params = {
				contact: {
					first_name: "John",
					last_name: "Smith",
					company_id: @company.id,
					email: "john@example.com",
					phone_number: "123-555-6789",
					notes: "Notes here...",
				},
				job_application_id: job_application.id
			}

			post api_v1_user_contacts_path(@user1.id), params: contact_params , headers: { "Authorization" => "Bearer #{@token}" }, as: :json

			expect(response).to have_http_status(:created)
			
			expect(job_application.reload.contact_id).to eq(nil)
		end

		it 'creates contact and assigns it to a job application if jobApplicationId params is present ' do 
			job_application = JobApplication.create!(
				position_title: "Jr. CTO",
				date_applied: "2024-10-31",
				status: :submitted,
				notes: "Fingers crossed!",
				job_description: "Looking for Turing grad/jr dev to be CTO",
				application_url: "www.example1.com",
				company: @company,
				user: @user1,
    	)

			contact_params = {
				contact: {
					first_name: "John",
					last_name: "Smith",
					company_id: @company.id,
					email: "john@example.com",
					phone_number: "123-555-6789",
					notes: "Notes here...",
				},
				job_application_id: job_application.id
			}

			post api_v1_user_contacts_path(@user1.id), params: contact_params , headers: { "Authorization" => "Bearer #{@token}" }, as: :json

			expect(response).to have_http_status(:created)
			json = JSON.parse(response.body, symbolize_names: true)[:data]
			updated_contact_id = json[:id].to_i

			expect(job_application.reload.contact_id).to eq(updated_contact_id)
		end

		it 'will not assign a contact to a job application that belongs to another user' do
		  job_application = JobApplication.create!(
				position_title: "Jr. CTO",
				date_applied: "2024-10-31",
				status: :submitted,
				notes: "Fingers crossed!",
				job_description: "Looking for Turing grad/jr dev to be CTO",
				application_url: "www.example1.com",
				company: @company,
				user: @user2,
    	)

			contact_params = {
				contact: {
					first_name: "John",
					last_name: "Smith",
					company_id: @company.id,
					email: "john@example.com",
					phone_number: "123-555-6789",
					notes: "Notes here...",
				},
				job_application_id: job_application.id
			}

			post api_v1_user_contacts_path(@user1.id), params: contact_params , headers: { "Authorization" => "Bearer #{@token}" }, as: :json

			expect(response).to have_http_status(:created)
			
			expect(job_application.reload.contact_id).to eq(nil)
		end
	end
	
	context "when the request is invalid - Sad Paths" do
		before(:each) do
			@user1 = create(:user)
			user_params = { email: @user1.email, password: @user1.password }
			post api_v1_sessions_path, params: user_params, as: :json
			@token = JSON.parse(response.body)["token"]

			@company = create(:company, user: @user1)
		end 

		it "returns a 422 error for missing first_name" do
			missing_contact_params = { contact: { first_name: "", last_name: Faker::Name.last_name } }

			post api_v1_user_contacts_path(@user1.id), params: missing_contact_params, headers: { "Authorization" => "Bearer #{@token}" }, as: :json

			expect(response).to have_http_status(:unprocessable_entity)
			json = JSON.parse(response.body, symbolize_names: true)
			expect(json[:message]).to include("First name can't be blank")
			expect(json[:status]).to eq(422)
		end

		it "returns a 422 error for missing last_name" do
			missing_contact_params = { contact: { first_name: Faker::Name.first_name, last_name: "" } }

			post api_v1_user_contacts_path(@user1.id), params: missing_contact_params, headers: { "Authorization" => "Bearer #{@token}" }, as: :json

			expect(response).to have_http_status(:unprocessable_entity)
			json = JSON.parse(response.body, symbolize_names: true)
			expect(json[:message]).to include("Last name can't be blank")
			expect(json[:status]).to eq(422)
		end

		it "returns a 422 error for invalid email format" do
			invalid_email_params = { contact: { first_name: Faker::Name.first_name, last_name: Faker::Name.last_name, email: "invalid-email" } }

			post api_v1_user_contacts_path(@user1.id), params: invalid_email_params, headers: { "Authorization" => "Bearer #{@token}" }, as: :json

			expect(response).to have_http_status(:unprocessable_entity)
			json = JSON.parse(response.body, symbolize_names: true)
			expect(json[:message]).to include("Email must be a valid email address")
			expect(json[:status]).to eq(422)
		end

		it "returns a 422 error for an invalid phone number format" do
			invalid_phone_params = { contact: { first_name: Faker::Name.first_name, last_name: Faker::Name.last_name, phone_number: "555555555" } }

			post api_v1_user_contacts_path(@user1.id), params: invalid_phone_params, headers: { "Authorization" => "Bearer #{@token}" }, as: :json

			expect(response).to have_http_status(:unprocessable_entity)
			json = JSON.parse(response.body, symbolize_names: true)
			expect(json[:message]).to include("Phone number must be in the format '555-555-5555'")
			expect(json[:status]).to eq(422)
		end

		it 'returns a 404 error when a company is not found by ID number' do
			minimal_params =  { contact: {first_name: Faker::Name.first_name, last_name: Faker::Name.last_name } }
			post api_v1_user_company_contacts_path(user_id: @user1.id, company_id: 99999), params: minimal_params , headers: { "Authorization" => "Bearer #{@token}" }, as: :json
			
			expect(response).to have_http_status(:not_found)
			json = JSON.parse(response.body, symbolize_names: true)
			
			expect(json[:message]).to include("Company not found")
			expect(json[:status]).to eq(404)
		end
	end

	context "edge cases - Sad Paths" do
		before(:each) do
			@user1 = create(:user)
			user_params = { email: @user1.email, password: @user1.password }
			post api_v1_sessions_path, params: user_params, as: :json
			@token = JSON.parse(response.body)["token"]

			@company = create(:company, user: @user1)
		end

		it "returns a 401 error if no token is provided" do
			contact_params = { contact: { first_name: Faker::Name.first_name, last_name: Faker::Name.last_name } }

			post api_v1_user_contacts_path(@user1.id), params: contact_params, as: :json

			expect(response).to have_http_status(:unauthorized)
			json = JSON.parse(response.body, symbolize_names: true)
			expect(json[:error]).to eq("Not authenticated")
		end

		it "returns a 401 error for invalid token" do
			contact_params = { contact: { first_name: Faker::Name.first_name, last_name: Faker::Name.last_name } }

			post api_v1_user_contacts_path(@user1.id), params: contact_params, headers: { "Authorization" => "Bearer invalid.token" }, as: :json

			expect(response).to have_http_status(:unauthorized)
			json = JSON.parse(response.body, symbolize_names: true)
			expect(json[:error]).to eq("Not authenticated")
		end
	end
end
