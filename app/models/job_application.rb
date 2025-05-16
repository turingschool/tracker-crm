class JobApplication < ApplicationRecord
  belongs_to :company
  belongs_to :user
  belongs_to :contact, optional: true
  has_many :interview_questions
  
  enum status: {
    submitted: 1,
    interviewing: 2,
    offer: 3,
    rejected: 4,
    phone_screen: 5,
    code_challenge: 6, 
    not_yet_applied: 7
  }

  validates :position_title, presence: true
  validates :date_applied, presence: true, unless: :application_pending_submission?
  validates :status, presence: true
  validates :job_description, presence: true
  validates :application_url, presence: true
  validates :company_id, presence: true
  validates :contact, presence: true, if: :contact_id_present?

  private

  def contact_id_present?
    contact_id.present?
  end

  def application_pending_submission?
    not_yet_applied?
  end
end
