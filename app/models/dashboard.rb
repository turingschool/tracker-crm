class Dashboard < ApplicationRecord
  def self.filter_weekly_summary(user)
    {
      job_applications: user.job_applications.where('created_at >= ?', 7.days.ago),
      contacts: user.contacts.where('created_at >= ?', 7.days.ago),
      companies: user.companies.where('created_at >= ?', 7.days.ago)
    }
  end
end