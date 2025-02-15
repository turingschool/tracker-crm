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

      expect(Dashboard.filter_weekly_summary(user)).to eq({
        job_applications: [],
        contacts: [contact],
        companies: [company_2]
      })
    end
  end
end