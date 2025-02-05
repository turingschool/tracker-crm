class Company < ApplicationRecord
  rolify strict: true
  belongs_to :user 
  has_many :contacts
  has_many :job_applications
  
  validates :name, presence: true

  def self.find_company(user, company_id)
    if company = user.companies.find_by(id: company_id)
      return company
    else
      return false
    end
  end
end
