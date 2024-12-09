# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
User.create!(name: "Danny DeVito", email: "danny_de@email.com", password: "jerseyMikesRox7")
User.create!(name: "Dolly Parton", email: "dollyP@email.com", password: "Jolene123")
User.create!(name: "Lionel Messi", email: "futbol_geek@email.com", password: "test123")

user = User.create!(name: "Jane Doe", email: "123@email.com", password: "Abc123")
Contact.create!(
  first_name: "John",
  last_name: "Smith",
  company_id: 1,
  email: "123@example.com",
  phone_number: "(123) 555-6789",
  notes: "Type notes here...",
  user_id: user.id
  )
Contact.create!(
  first_name: "Jane",
  last_name: "Smith",
  company_id: 1,
  email: "123@example.com",
  phone_number: "(123) 555-6789",
  notes: "Type notes here...",
  user_id: user.id
  )

JobApplication.create!(
  position_title: "Jr. CTO",
  date_applied: "2024-10-31",
  status: 1,
  notes: "Fingers crossed!",
  job_description: "Looking for Turing grad/jr dev to be CTO",
  application_url: "www.example.com",
  contact_information: "boss@example.com",
  company_id: 1
)
