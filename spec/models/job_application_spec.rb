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

    it "allows job application to be valid without a contact_id" do
      job_application_without_contact = JobApplication.create!(
        position_title: "Jr. CTO",
        date_applied: "2024-10-31",
        status: 1,
        notes: "Fingers crossed!",
        job_description: "Looking for Turing grad/jr dev to be CTO",
        application_url: "www.different-example.com",
        company_id: subject.company_id,
        user_id: subject.user_id,
        contact_id: nil  
      )

      expect(job_application_without_contact).to be_valid
    end

    it "validates presence of contact if contact_id is provided" do
      contact = Contact.create!(
        first_name: "John",
        last_name: "Doe",
        email: "john.doe@example.com",
        user_id: subject.user_id
      )

      job_application_with_contact = JobApplication.create!(
        position_title: "Jr. CTO",
        date_applied: "2024-10-31",
        status: 1,
        notes: "Fingers crossed!",
        job_description: "Looking for Turing grad/jr dev to be CTO",
        application_url: "www.example-with-contact.com",
        company_id: subject.company_id,
        user_id: subject.user_id,
        contact_id: contact.id  
      )

      expect(job_application_with_contact).to be_valid
    end
  end

  describe "associations" do
    it { should belong_to(:company) }
    it { should belong_to(:user) }
    it { should belong_to(:contact).optional }
    it { should have_many(:interview_questions)}
  end
end