class JobApplication < ApplicationRecord
  belongs_to :company
  belongs_to :user

  validates :position_title, presence: true
  validates :date_applied, presence: true
  validates :status, presence: true
  validates :job_description, presence: true
  validates :application_url, presence: true, uniqueness: { scope: :user_id, message: "already exists for the user, try making a new application with a new URL." }
  validates :company_id, presence: true
end
