class Company < ApplicationRecord
  # rolify strict: true
  belongs_to :user 
  has_many :contacts
  has_many :job_applications, dependent: :destroy
  
  validates :name, presence: true, allow_blank: false
  validates :website, presence: true, allow_blank: false
  validates :street_address, presence: true, allow_blank: false
  validates :city, presence: true, allow_blank: false
  validates :state, presence: true, allow_blank: false
  validates :zip_code, presence: true, allow_blank: false
  validates :notes, presence: true, allow_nil: true

  def self.find_company(user, company_id)
    if company = user.companies.find_by(id: company_id)
      return company
    else
      return nil
    end
  end

  def handle_deletion
    contacts.update_all(company_id: nil)
    destroy
  end
end
