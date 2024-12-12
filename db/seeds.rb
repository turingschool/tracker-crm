# Create Users
users = [
  { name: "Danny DeVito", email: "danny_de@email.com", password: "jerseyMikesRox7" },
  { name: "Dolly Parton", email: "dollyP@email.com", password: "Jolene123" },
  { name: "Lionel Messi", email: "futbol_geek@email.com", password: "test123" }
]


users.each do |user_data|
  User.find_or_create_by!(email: user_data[:email]) do |user|
    user.name = user_data[:name]
    user.password = user_data[:password]
  end
end

# Fetch the created users
first_user = User.find_by(email: "danny_de@email.com")
second_user = User.find_by(email: "dollyP@email.com")

# Create Companies
companies = [
  {
    name: 'Tech Innovators',
    website: 'https://techinnovators.com',
    street_address: '123 Innovation Way',
    city: 'San Francisco',
    state: 'CA',
    zip_code: '94107',
    notes: 'Reached out on LinkedIn, awaiting response.',
    user_id: first_user.id
  },
  {
    name: 'Future Designs LLC',
    website: 'https://futuredesigns.com',
    street_address: '456 Future Blvd',
    city: 'Austin',
    state: 'TX',
    zip_code: '73301',
    notes: 'Submitted application for the UI Designer role.',
    user_id: second_user.id
  },
  {
    name: 'Creative Solutions Inc.',
    website: 'https://creativesolutions.com',
    street_address: '789 Creative Street',
    city: 'Seattle',
    state: 'WA',
    zip_code: '98101',
    notes: 'Follow up scheduled for next week.',
    user_id: first_user.id
  }
]

companies.each do |company_data|
  Company.find_or_create_by!(name: company_data[:name]) do |company|
    company.assign_attributes(company_data)
  end
end

# Create Job Applications
job_applications = [
  {
    position_title: "Jr. CTO",
    date_applied: "2024-10-31",
    status: 1,
    notes: "Fingers crossed!",
    job_description: "Looking for Turing grad/jr dev to be CTO",
    application_url: "www.example.com",
    contact_information: "boss@example.com",
    company_id: Company.find_by(name: "Tech Innovators").id,
    user_id: User.find_by(email: "danny_de@email.com").id
  },
  {
    position_title: "UI Designer",
    date_applied: "2024-09-15",
    status: 0,
    notes: "Submitted portfolio and waiting for feedback.",
    job_description: "Designing innovative and user-friendly interfaces.",
    application_url: "https://futuredesigns.com/jobs/ui-designer",
    contact_information: "hr@futuredesigns.com",
    company_id: Company.find_by(name: "Future Designs LLC").id,
    user_id: User.find_by(email: "dollyP@email.com").id
  },
  {
    position_title: "Backend Developer",
    date_applied: "2024-08-20",
    status: 2,
    notes: "Had a technical interview, awaiting decision.",
    job_description: "Developing RESTful APIs and optimizing server performance.",
    application_url: "https://creativesolutions.com/careers/backend-developer",
    contact_information: "techlead@creativesolutions.com",
    company_id: Company.find_by(name: "Creative Solutions Inc.").id,
    user_id: User.find_by(email: "danny_de@email.com").id
  },
  {
    position_title: "Data Analyst",
    date_applied: "2024-07-05",
    status: 1,
    notes: "Excited to work with their data-driven team.",
    job_description: "Analyzing complex datasets to provide actionable insights.",
    application_url: "https://futuredesigns.com/jobs/data-analyst",
    contact_information: "analytics@futuredesigns.com",
    company_id: Company.find_by(name: "Future Designs LLC").id,
    user_id: User.find_by(email: "futbol_geek@email.com").id
  },
  {
    position_title: "Full-Stack Engineer",
    date_applied: "2024-10-10",
    status: 1,
    notes: "Great team, excited about the potential role!",
    job_description: "Developing and maintaining both client-side and server-side applications.",
    application_url: "https://techinnovators.com/careers/full-stack-engineer",
    contact_information: "hiring@techinnovators.com",
    company_id: Company.find_by(name: "Tech Innovators").id,
    user_id: User.find_by(email: "futbol_geek@email.com").id
  }
]

job_applications.each do |application_data|
  JobApplication.find_or_create_by!(
    position_title: application_data[:position_title],
    company_id: application_data[:company_id],
    user_id: application_data[:user_id]
  ) do |job_application|
    job_application.assign_attributes(application_data)
  end
end

