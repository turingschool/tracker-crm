class Contact < ApplicationRecord
  belongs_to :user
  belongs_to :company, optional: true

  VALID_PHONE_REGEX = /\A\d{3}\-\d{3}-\d{4}\z/
  VALID_EMAIL_REGEX = /\A[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}\z/

  before_validation :normalize_names

  validates :first_name, presence: {message: "can't be blank"} 
  validates :last_name, presence: {message: "can't be blank"}

  validates :phone_number, format: { with: VALID_PHONE_REGEX, message: "must be in the format '555-555-5555'" }, allow_blank: true
  validates :email, format: { with: VALID_EMAIL_REGEX, message: "must be a valid email address" }, allow_blank: true

  def update_contact(params)
    update(params)
  end
  
  def self.create_optional_company(contact_params, user_id, company_id)
    attributes = contact_params.merge(user_id: user_id)
    attributes[:company_id] = company_id if company_id.present?
    create(attributes)
  end

  private

  def normalize_names
    self.first_name = first_name.strip.capitalize if first_name.present?
    self.last_name = last_name.strip.capitalize if last_name.present?
  end
end
