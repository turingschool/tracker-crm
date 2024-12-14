class DashboardSerializer
  include JSONAPI::Serializer
  attributes :id, :name, :email

  attribute :dashboard do |user|
    {
      weekly_summary: {
        job_applications: user.job_applications,
        contacts: user.contacts,
        companies: user.companies
      }
    }
  end
end
