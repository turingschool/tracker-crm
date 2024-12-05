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



# rails generate migration CreateJobApplication position_title:string company:string date_applied:date status:integer notes:text job_description:text application_url:string contact_information:text
# rails generate migration CreateJobApplication position_title:string date_applied:date status:integer notes:text job_description:text application_url:string contact_information:text company_id: null
