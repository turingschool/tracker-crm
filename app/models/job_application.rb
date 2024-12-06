class JobApplication < ApplicationRecord
  belongs_to :company
  belongs_to :user

  validates :position_title, presence: true
  validates :date_applied, presence: true
  validates :status, presence: true
  validates :job_description, presence: true
  validates :application_url, presence: true
  validates :contact_information, presence: true
  validates :company_id, presence: true
end
