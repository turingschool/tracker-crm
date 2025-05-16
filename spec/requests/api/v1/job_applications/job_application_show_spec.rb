require "rails_helper"

RSpec.describe "Job Application #show", type: :request do
  describe "Show Job Application" do
    before(:each) do
      @user = User.create!(name: "Dolly Parton", email: "dollyP123@email.com", password: "Jolene123")

      @google = Company.create!(user_id: @user.id, name: "Google", website: "google.com", street_address: "1600 Amphitheatre Parkway", city: "Mountain View", state: "CA", zip_code: "94043", notes: "Search engine")

      @facebook = Company.create!(user_id: @user.id, name: "Facebook", website: "facebook.com", street_address: "1 Hacker Way", city: "Menlo Park", state: "CA", zip_code: "94025", notes: "Social media")

      @amazon = Company.create!(user_id: @user.id, name: "Amazon", website: "amazon.com", street_address: "410 Terry Ave N", city: "Seattle", state: "WA", zip_code: "98109", notes: "E-commerce")

      @google_application = JobApplication.create!(
        position_title: "Crank Operator",
        date_applied: "2024-10-31",
        status: :submitted,
        notes: "Not sure im familiar with the tech-stack",
        job_description: "You turn the big crank that powers google",
        application_url: "www.example.com",
        company_id: @google.id,
        user_id: @user.id
      )

      @facebook_application = JobApplication.create!(
        position_title: "Smiler",
        date_applied: "2024-10-31",
        status: :submitted,
        notes: "Visit dentist before interview!!!",
        job_description: "Raise the facility smile rates.",
        application_url: "www.example.com/secret_param",
        company_id: @facebook.id,
        user_id: @user.id
      )

      @google_application = JobApplication.create!(
        position_title: "Hallway Enrichment",
        date_applied: "2024-10-31",
        status: :submitted,
        job_description: "Make our hallways look fresh and clean",
        application_url: "www.example.com/super_secret_param",
        company_id: @amazon.id,
        user_id: @user.id
      )

      @john = Contact.create!(
        first_name: "John", 
        last_name: "Smith", 
        company_id: @facebook.id, 
        email: "123@example.com", 
        phone_number: "123-555-6789", 
        notes: "Notes here...", 
        user_id: @user.id)

        @hody = Contact.create!(
        first_name: "Hody", 
        last_name: "Jones", 
        company_id: @facebook.id, 
        email: "fishman4lyf3@gmail.com", 
        phone_number: "484-321-1738", 
        notes: "This guy...", 
        user_id: @user.id)
    end

    context "happy path" do
      it "Returns the specified instance of a user's job applications" do

        post api_v1_sessions_path, params: { email: @user.email, password: "Jolene123" }, as: :json
        
        token = JSON.parse(response.body)["token"]
        
        get "/api/v1/users/#{@user.id}/job_applications/#{@facebook_application.id}", 
        headers: {"Authorization" => "Bearer #{token}" }, as: :json

        expect(response).to be_successful
        expect(response.status).to eq(200)

        jobApp = JSON.parse(response.body, symbolize_names: true)

        expect(jobApp[:data][:type]).to eq("job_application")
        expect(jobApp[:data][:id]).to eq(@facebook_application.id.to_s)
        expect(jobApp[:data][:attributes][:position_title]).to eq(@facebook_application[:position_title])
        expect(jobApp[:data][:attributes][:date_applied]).to eq(@facebook_application[:date_applied].to_s)
        expect(jobApp[:data][:attributes][:status]).to eq(JobApplication.statuses[@facebook_application.status])
        expect(jobApp[:data][:attributes][:notes]).to eq(@facebook_application[:notes])
        expect(jobApp[:data][:attributes][:job_description]).to eq(@facebook_application[:job_description])
        expect(jobApp[:data][:attributes][:application_url]).to eq(@facebook_application[:application_url])
        expect(jobApp[:data][:attributes][:company_id]).to eq(@facebook_application[:company_id])      
        expect(jobApp[:data][:attributes][:contacts].length).to eq(2)
        expect(jobApp[:data][:attributes][:contacts][0][:first_name]).to eq(@john[:first_name])
      end
    end

    context "sad path" do

      it "returns error serializer if job application id does not exist" do

        post api_v1_sessions_path, params: { email: @user.email, password: "Jolene123" }, as: :json
        
        token = JSON.parse(response.body)["token"]
        
        get "/api/v1/users/#{@user.id}/job_applications/0", 
        headers: {"Authorization" => "Bearer #{token}" }, as: :json

        expect(response).to_not be_successful
        expect(response.status).to eq(404)

        json = JSON.parse(response.body, symbolize_names: true)


        expect(json[:message]).to eq("Job application not found")
        expect(json[:status]).to eq(404)
      end

      it "returns error serializer if job application id belongs to another user" do
        user_2 = User.create!(name: "Daniel Averdaniel", email: "daderdaniel@gmail.com", password: "nuggetonnabiscut")
  
        user_2_application = JobApplication.create!(
          position_title: "Crank Operator",
          date_applied: "2024-10-31",
          status: :submitted,
          notes: "Not sure im familiar with the tech-stack",
          job_description: "You turn the big crank that powers google",
          application_url: "www.example.com",
          company_id: @google.id,
          user_id: user_2.id
        )

        post api_v1_sessions_path, params: { email: @user.email, password: "Jolene123" }, as: :json
        
        token = JSON.parse(response.body)["token"]

        get "/api/v1/users/#{@user.id}/job_applications/#{user_2_application.id}",  
        headers: {"Authorization" => "Bearer #{token}" }, as: :json

        expect(response).to_not be_successful
        expect(response.status).to eq(404)

        json = JSON.parse(response.body, symbolize_names: true)

        expect(json[:message]).to eq("Job application not found")
        expect(json[:status]).to eq(404)
      end

      # it "returns error serializer if no params are passed in URL for job application id" do

      #   post api_v1_sessions_path, params: { email: @user.email, password: "Jolene123" }, as: :json
        
      #   token = JSON.parse(response.body)["token"]

      #    params = nil

      #   get "/api/v1/users/#{@user.id}/job_applications/#{params}",
      #   # params: {id: nil},
      #   headers: {"Authorization" => "Bearer #{token}" }, as: :json

      #   expect(response).to_not be_successful
      #   expect(response.status).to eq(400)

      #   json = JSON.parse(response.body, symbolize_names: true)

      #   expect(json[:message]).to eq("Job application ID is missing")
      #   expect(json[:status]).to eq(400)
      # end
    end
  end
end