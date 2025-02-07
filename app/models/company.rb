class Company < ApplicationRecord
  # rolify strict: true
  belongs_to :user 
  has_many :contacts
  has_many :job_applications, dependent: :destroy
  
  validates :name, presence: true

  def handle_deletion
    contacts.update_all(company_id: nil)
    destroy
  end
end
