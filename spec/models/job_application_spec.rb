require "rails_helper"

RSpec.describe JobApplication, type: :model do
  describe "validations" do
    it { should validate_presence_of(:position_title) }
    it { should validate_presence_of(:date_applied) }
    it { should validate_presence_of(:status) }
    it { should validate_presence_of(:job_description) }
    it { should validate_presence_of(:application_url) }
    it { should validate_presence_of(:contact_information) }
    it { should validate_presence_of(:company_id) }
  end

  describe "associations" do
    it { should belong_to(:company) }
    it { should belong_to(:user) }
  end
  describe ".validate_job_app_uniqueness" do
    it "returns false if a application URL for the given job application exists for the user" do
      user = User.create!(name: "Yolonda Aberdeer", email: "yolodeer@aol.com", password: "nuggetbisket")

      google = Company.create!(
        user_id: user.id,
        name: "Google",
        website: "google.com",
        street_address: "1600 Amphitheatre Parkway",
        city: "Mountain View",
        state: "CA",
        zip_code: "94043",
        notes: "Search engine"
      )

      JobApplication.create!(
        position_title: "Jr. CTO",
        date_applied: "2024-10-31",
        status: 1,
        notes: "Fingers crossed!",
        job_description: "Looking for Turing grad/jr dev to be CTO",
        application_url: "www.example.com",
        contact_information: "boss@example.com",
        company_id: google.id,
        user_id: user.id
      )

      expect(user.job_applications.length).to eq(1)

      expect(JobApplication.validate_job_app_uniqueness(user, "www.example.com")).to eq(false)

    end

    it "returns true if a application URL for the given job application does not exists for the user" do
      user = User.create!(name: "Yolonda Aberdeer", email: "yolodeer@aol.com", password: "nuggetbisket")

      google = Company.create!(
        user_id: user.id,
        name: "Google",
        website: "google.com",
        street_address: "1600 Amphitheatre Parkway",
        city: "Mountain View",
        state: "CA",
        zip_code: "94043",
        notes: "Search engine"
      )

      JobApplication.create!(
        position_title: "Jr. CTO",
        date_applied: "2024-10-31",
        status: 1,
        notes: "Fingers crossed!",
        job_description: "Looking for Turing grad/jr dev to be CTO",
        application_url: "www.example.com",
        contact_information: "boss@example.com",
        company_id: google.id,
        user_id: user.id
      )

      expect(user.job_applications.length).to eq(1)

      expect(JobApplication.validate_job_app_uniqueness(user, "www.new-url.com")).to eq(true)

    end

    it "should allows two users to both save the same job application" do
      user_1 = User.create!(name: "Yolonda Aberdeer", email: "yolodeer@aol.com", password: "nuggetbisket")
      user_2 = User.create!(name: "Daniel Averdaniel", email: "daderdaniel@gmail.com", password: "nuggetbisketinnabisket")

      google = Company.create!(
        user_id: user_1.id,
        name: "Google",
        website: "google.com",
        street_address: "1600 Amphitheatre Parkway",
        city: "Mountain View",
        state: "CA",
        zip_code: "94043",
        notes: "Search engine"
      )

      twoogle = Company.create!(
        user_id: user_2.id,
        name: "Google",
        website: "google.com",
        street_address: "1600 Amphitheatre Parkway",
        city: "Mountain View",
        state: "CA",
        zip_code: "94043",
        notes: "Search engine"
      )

      job_app_1 = JobApplication.create!(
        position_title: "Jr. CTO",
        date_applied: "2024-10-31",
        status: 1,
        notes: "Fingers crossed!",
        job_description: "Looking for Turing grad/jr dev to be CTO",
        application_url: "www.example.com",
        contact_information: "boss@example.com",
        company_id: google.id,
        user_id: user_1.id
      )

      job_app_2 = JobApplication.create!(
        position_title: "Jr. CTO",
        date_applied: "2024-10-31",
        status: 1,
        notes: "Fingers crossed!",
        job_description: "Looking for Turing grad/jr dev to be CTO",
        application_url: "www.example.com",
        contact_information: "boss@example.com",
        company_id: twoogle.id,
        user_id: user_2.id
      )

      expect(user_1.job_applications.length).to eq(1)
      expect(user_2.job_applications.length).to eq(1)

    end
  end
end