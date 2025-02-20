require "rails_helper"

RSpec.describe Dashboard, type: :model do
  describe "dashboard data" do
    it "can filter data to only return if it was created less than a week ago" do
      user = User.create!(name: "Danny DeVito", email: "danny_de@email.com", password: "jerseyMikesRox7")
      company = Company.create!(
        user_id: user.id,
        name: "Google",
        website: "google.com",
        street_address: "1600 Amphitheatre Parkway",
        city: "Mountain View",
        state: "CA",
        zip_code: "94043",
        notes: "Search engine",
        created_at: 9.days.ago)
      company_2 = Company.create!(
        name: "Turing", 
        website: "www.turing.com", 
        street_address: "123 Main St",
        city: "Denver",
        state: "CO",
        zip_code: "80218",
        user_id: user.id,
        created_at: 2.days.ago)
      contact = Contact.create!(first_name: "John", last_name: "Smith", user_id: user.id, company: company, created_at: 3.days.ago)
      job_application = JobApplication.create!(
        position_title: "Jr. CTO",
        date_applied: "2024-10-31",
        status: 1,
        notes: "Fingers crossed!",
        job_description: "Looking for Turing grad/jr dev to be CTO",
        application_url: "www.example.com",
        company_id: company.id,
        user_id: user.id,
        created_at: 8.days.ago
      )
      expect(Dashboard.filter_weekly_summary(user)).to eq({
        job_applications: [],
        contacts: [contact],
        companies: [company_2]
      })
    end

    it "returns an empty array if no new data in the past week" do
      user = User.create!(name: "Danny DeVito", email: "danny_de@email.com", password: "jerseyMikesRox7")
      company = Company.create!(
        user_id: user.id,
        name: "Google",
        website: "google.com",
        street_address: "1600 Amphitheatre Parkway",
        city: "Mountain View",
        state: "CA",
        zip_code: "94043",
        notes: "Search engine",
        created_at: 9.days.ago)
      company_2 = Company.create!(
        name: "Turing", 
        website: "www.turing.com", 
        street_address: "123 Main St",
        city: "Denver",
        state: "CO",
        zip_code: "80218",
        user_id: user.id,
        created_at: 10.days.ago)
      contact = Contact.create!(first_name: "John", last_name: "Smith", user_id: user.id, company: company, created_at: 9.days.ago)
      job_application = JobApplication.create!(
        position_title: "Jr. CTO",
        date_applied: "2024-10-31",
        status: 1,
        notes: "Fingers crossed!",
        job_description: "Looking for Turing grad/jr dev to be CTO",
        application_url: "www.example.com",
        company_id: company.id,
        user_id: user.id,
        created_at: 8.days.ago
      )
      expect(Dashboard.filter_weekly_summary(user)).to eq({
        job_applications: [],
        contacts: [],
        companies: []
      })
    end

    it "returns an empty array if the data is exactly 7 days old" do
      user = User.create!(name: "Danny DeVito", email: "danny_de@email.com", password: "jerseyMikesRox7")
      company = Company.create!(
        user_id: user.id,
        name: "Google",
        website: "google.com",
        street_address: "1600 Amphitheatre Parkway",
        city: "Mountain View",
        state: "CA",
        zip_code: "94043",
        notes: "Search engine",
        created_at: 7.days.ago)
      company_2 = Company.create!(
        name: "Turing", 
        website: "www.turing.com", 
        street_address: "123 Main St",
        city: "Denver",
        state: "CO",
        zip_code: "80218",
        user_id: user.id,
        created_at: 6.days.ago.end_of_day)
      contact = Contact.create!(first_name: "John", last_name: "Smith", user_id: user.id, company: company, created_at: 7.days.ago)
      job_application = JobApplication.create!(
        position_title: "Jr. CTO",
        date_applied: "2024-10-31",
        status: 1,
        notes: "Fingers crossed!",
        job_description: "Looking for Turing grad/jr dev to be CTO",
        application_url: "www.example.com",
        company_id: company.id,
        user_id: user.id,
        created_at: 7.days.ago
      )
      expect(Dashboard.filter_weekly_summary(user)).to eq({
        job_applications: [],
        contacts: [],
        companies: [company_2]
      })
    end

    it "returns data for only the given user" do
      user = User.create!(name: "Danny DeVito", email: "danny_de@email.com", password: "jerseyMikesRox7")
      user_2 = User.create!(name: "Yolonda Aberdeer", email: "yolodeer@aol.com", password: "nuggetbisket"
      )
      company = Company.create!(
        user_id: user_2.id,
        name: "Google",
        website: "google.com",
        street_address: "1600 Amphitheatre Parkway",
        city: "Mountain View",
        state: "CA",
        zip_code: "94043",
        notes: "Search engine",
        created_at: 3.days.ago)
      company_2 = Company.create!(
        name: "Turing", 
        website: "www.turing.com", 
        street_address: "123 Main St",
        city: "Denver",
        state: "CO",
        zip_code: "80218",
        user_id: user.id,
        created_at: 3.days.ago)
      contact = Contact.create!(first_name: "John", last_name: "Smith", user_id: user_2.id, company: company, created_at: 3.days.ago)
      job_application = JobApplication.create!(
        position_title: "Jr. CTO",
        date_applied: "2024-10-31",
        status: 1,
        notes: "Fingers crossed!",
        job_description: "Looking for Turing grad/jr dev to be CTO",
        application_url: "www.example.com",
        company_id: company.id,
        user_id: user_2.id,
        created_at: 14.days.ago
      )
      expect(Dashboard.filter_weekly_summary(user_2)).to eq({
        job_applications: [],
        contacts: [contact],
        companies: [company]
      })
    end    
  end
end