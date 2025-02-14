class DashboardSerializer
  include JSONAPI::Serializer
  attributes :id, :name, :email

  attribute :dashboard do |user|
    {
      weekly_summary: {
        job_applications: user.job_applications.where('created_at >= ?', 7.days.ago),
        contacts: user.contacts.where('created_at >= ?', 7.days.ago),
        companies: user.companies.where('created_at >= ?', 7.days.ago)
      }
    }
  end
end
