FactoryBot.define do
  factory :job_application do
    position_title { Faker::Job.title }
    date_applied { Faker::Date.between(from: 4.days.ago, to: Date.today) }
    status { Faker::Number.within(range: 1..7) }
    job_description { "#{Faker::Job.seniority} #{Faker::Job.field} #{Faker::Job.field}"}
    notes { "Education Level: #{Faker::Job.education_level}, Employment Type: #{Faker::Job.employment_type}"}
    application_url { "http://www.#{company.name.gsub(/\s+/, '')}.com/jobs/#{position_title.gsub(/\s+/, '')}" }
    
    company
    user
  end
end