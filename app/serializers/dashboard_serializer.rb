class DashboardSerializer
  include JSONAPI::Serializer
  attributes :id, :name, :email

  has_many :job_applications, serializer: JobApplicationSerializer
  has_many :contacts, serializer: ContactsSerializer
  has_many :companies, serializer: CompanySerializer

  attribute :dashboard do |user|
    {
      weekly_summary: {
        job_applications: user.job_applications,
        new_contacts: user.contacts,
        companies: user.companies
      }
    }
  end
end
