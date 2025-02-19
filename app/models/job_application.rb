class JobApplication < ApplicationRecord
  belongs_to :company
  belongs_to :user
  belongs_to :contact, optional: true

  validates :position_title, presence: true
  validates :date_applied, presence: true
  validates :status, presence: true
  validates :job_description, presence: true
  validates :application_url, presence: true
  validates :company_id, presence: true
  validates :contact, presence: true, if: :contact_id_present?

  private

  def contact_id_present?
    contact_id.present?
  end
end
