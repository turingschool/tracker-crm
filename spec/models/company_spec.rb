require 'rails_helper'

RSpec.describe Company, type: :model do
  describe "associations" do
    it { should belong_to(:user) }
    it { should have_many(:contacts) }
    it { should have_many(:job_applications).dependent(:destroy) }
  end

  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should_not validate_presence_of(:website) }
    it { should_not validate_presence_of(:street_address) }
    it { should_not validate_presence_of(:city) }
    it { should_not validate_presence_of(:state) }
    it { should_not validate_presence_of(:zip_code) }
    it { should_not validate_presence_of(:notes) }
  end

  describe "#handle_deletion" do
    before(:each) do
      @user = User.create!(name: "Yolonda Aberdeer", email: "yolodeer@aol.com", password: "nuggetbisket")

      @company = Company.create!(
        user: @user,
        name: "Google",
        website: "google.com",
        street_address: "1600 Amphitheatre Parkway",
        city: "Mountain View",
        state: "CA",
        zip_code: "94043",
        notes: "Search engine"
      )

      @contact1 = Contact.create!(first_name: "John", last_name: "Doe", user: @user, company: @company)
      @contact2 = Contact.create!(first_name: "Jane", last_name: "Smith", user: @user, company: @company)
      
      @job_application = JobApplication.create!(
        position_title: "Jr. CTO",
        date_applied: "2024-10-31",
        status: 1,
        notes: "Fingers crossed!",
        job_description: "Looking for Turing grad/jr dev to be CTO",
        application_url: "www.example.com",
        company: @company,
        user: @user
      )
    end

    it "removes the company_id from associated contacts but does not delete them" do
      expect(@contact1.company_id).to eq(@company.id)
      expect(@contact2.company_id).to eq(@company.id)

      @company.handle_deletion

      expect(@contact1.reload.company_id).to be_nil
      expect(@contact2.reload.company_id).to be_nil
    end

    it "deletes associated job applications" do
      expect(JobApplication.find_by(id: @job_application.id)).not_to be_nil

      @company.handle_deletion

      expect(JobApplication.find_by(id: @job_application.id)).to be_nil
    end

    it "deletes the company" do
      expect(Company.find_by(id: @company.id)).not_to be_nil

      @company.handle_deletion

      expect(Company.find_by(id: @company.id)).to be_nil
    end
  end
end
