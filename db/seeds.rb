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

# Create Contacts
contacts = [
  {
    first_name: "John",
    last_name: "Doe",
    email: "john.doe@example.com",
    phone_number: "123-555-1234",
    notes: "Recruiter at Tech Innovators",
    user_id: User.find_by(email: "danny_de@email.com").id,
    company_id: Company.find_by(name: "Tech Innovators").id
  },
  {
    first_name: "Jane",
    last_name: "Smith",
    email: "jane.smith@example.com",
    phone_number: "123-555-5678",
    notes: "HR contact at Future Designs LLC",
    user_id: User.find_by(email: "dollyP@email.com").id,
    company_id: Company.find_by(name: "Future Designs LLC").id
  },
  {
    first_name: "Jim",
    last_name: "Steinman",
    email: "jim.steinman@example.com",
    phone_number: "123-555-6789",
    notes: "Musical Director at Future Designs LLC",
    user_id: User.find_by(email: "dollyP@email.com").id,
    company_id: Company.find_by(name: "Future Designs LLC").id
  },
  {
    first_name: "Michael",
    last_name: "Johnson",
    email: "michael.johnson@example.com",
    phone_number: "123-555-9012",
    notes: "Hiring manager at Creative Solutions Inc.",
    user_id: User.find_by(email: "danny_de@email.com").id,
    company_id: Company.find_by(name: "Creative Solutions Inc.").id
  },
  {
    first_name: "Emily",
    last_name: "Brown",
    email: "emily.brown@example.com",
    phone_number: "222-555-3456",
    notes: "Data lead at Future Designs LLC",
    user_id: User.find_by(email: "dollyP@email.com").id,
    company_id: Company.find_by(name: "Future Designs LLC").id
  },
  {
    first_name: "Sarah",
    last_name: "Lee",
    email: "sarah.lee@example.com",
    phone_number: "333-555-7890",
    notes: "Software lead at Tech Innovators",
    user_id: User.find_by(email: "danny_de@email.com").id,
    company_id: Company.find_by(name: "Tech Innovators").id
  }
]

contacts.each do |contact_data|
  Contact.find_or_create_by!(
    user_id: contact_data[:user_id],
    first_name: contact_data[:first_name],
    last_name: contact_data[:last_name]
  ) do |contact|
    contact.assign_attributes(contact_data)
  end
end

# Create Job Applications
job_applications = [
  {
    position_title: "Jr. CTO",
    date_applied: "2024-10-31",
    status: :submitted,
    notes: "Fingers crossed!",
    job_description: "Lorem ipsum dolor sit amet. Sed exercitationem recusandae ut totam tempora ut quibusdam quis et provident voluptatem sit quas ipsa. Cum dolorem temporibus aut galisum ratione non veritatis perspiciatis ea consequatur galisum aut fugit ullam hic ratione itaque qui dicta officia. Qui quia quidem ad porro illum et facilis voluptas qui possimus impedit aut dolorem temporibus eum exercitationem nulla in laudantium ipsam. Ea ipsum tenetur non delectus autem aut ipsum reiciendis sed voluptatem officiis et earum blanditiis qui magni modi est voluptatum repellendus? Ab eveniet voluptates est enim quaerat quo ipsa atque. Est reiciendis expedita rem iusto temporibus aut magnam iure ut eius dolorem in voluptatem aperiam! Et accusantium error et placeat quasi aut aperiam dolor est sint similique? Et consequuntur similique vel asperiores galisum 33 sint perspiciatis vel cupiditate nihil ab distinctio consequatur est fugiat ullam. Aut minus quia est aperiam impedit id rerum totam vel dolorem distinctio ut repellat quos in perferendis enim 33 cupiditate accusantium. In dolorum dolorem et enim aspernatur ut vero nesciunt? Rem beatae sequi id odio corporis eum fugiat reprehenderit. Vel accusamus nobis non Quis quia et dolores omnis. Cum ipsa magni ut totam incidunt id repudiandae animi hic ipsum dignissimos. Et accusantium explicabo ad enim velit qui fuga autem At placeat galisum! At fuga consequatur sit amet rerum vel obcaecati voluptatem et beatae corrupti ut minus autem ea fuga ratione ut consequatur ipsum. Aut eius impedit aut dignissimos voluptatibus aut velit voluptatem et veritatis voluptatem aut tempora facilis et officia labore. Ea nesciunt molestias non ullam enim et delectus obcaecati quo quas ducimus qui quia maiores qui numquam iusto. Hic libero eligendi vel quisquam omnis id libero voluptatem eum natus eius a ratione ipsa. Eos repellat alias et culpa quod 33 delectus laboriosam id dolor inventore aut aspernatur ipsum.",
    application_url: "www.example.com",
    company_id: Company.find_by(name: "Tech Innovators").id,
    user_id: User.find_by(email: "danny_de@email.com").id
  },
  {
    position_title: "UI Designer",
    date_applied: "2024-09-15",
    status: :submitted,
    notes: "Submitted portfolio and waiting for feedback.",
    job_description: "Designing innovative and user-friendly interfaces.",
    application_url: "https://futuredesigns.com/jobs/ui-designer",
    company_id: Company.find_by(name: "Future Designs LLC").id,
    user_id: User.find_by(email: "dollyP@email.com").id
  },
  {
    position_title: "Backend Developer",
    date_applied: "2024-08-20",
    status: :interviewing,
    notes: "Had a technical interview, awaiting decision.",
    job_description: "Developing RESTful APIs and optimizing server performance.",
    application_url: "https://creativesolutions.com/careers/backend-developer",
    company_id: Company.find_by(name: "Creative Solutions Inc.").id,
    user_id: User.find_by(email: "danny_de@email.com").id
  },
  {
    position_title: "Data Analyst",
    date_applied: "2024-07-05",
    status: :submitted,
    notes: "Excited to work with their data-driven team.",
    job_description: "Analyzing complex datasets to provide actionable insights.",
    application_url: "https://futuredesigns.com/jobs/data-analyst",
    company_id: Company.find_by(name: "Future Designs LLC").id,
    user_id: User.find_by(email: "futbol_geek@email.com").id
  },
  {
    position_title: "Full-Stack Engineer",
    date_applied: "2024-10-10",
    status: :submitted,
    notes: "Great team, excited about the potential role!",
    job_description: "Developing and maintaining both client-side and server-side applications.",
    application_url: "https://techinnovators.com/careers/full-stack-engineer",
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

