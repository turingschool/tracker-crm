require "rails_helper"

RSpec.describe JobApplication, type: :model do
  describe "validations" do
    it { should validate_presence_of(:position_title) }
    it { should validate_presence_of(:date_applied) }
    it { should validate_presence_of(:status) }
    it { should validate_presence_of(:job_description) }
    it { should validate_presence_of(:application_url) }
    it { should validate_presence_of(:company_id) }

    subject {
      user = User.create!(
        name: "Yolonda Aberdeer", 
        email: "yolodeer@aol.com", 
        password: "nuggetbisket"
      )

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
        company_id: google.id,
        user_id: user.id
      )
    }

    it "validates uniqueness of job application for a given user" do
      expect(subject).to validate_uniqueness_of(:application_url).scoped_to(:user_id).with_message("already exists for the user, try making a new application with a new URL.")
    end
  end

  describe "associations" do
    it { should belong_to(:company) }
    it { should belong_to(:user) }
  end
end