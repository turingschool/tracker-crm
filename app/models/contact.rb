class Contact < ApplicationRecord
  belongs_to :user
  belongs_to :company, optional: true

  VALID_PHONE_REGEX = /\A\d{3}\-\d{3}-\d{4}\z/
  VALID_EMAIL_REGEX = /\A[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}\z/

  validates :first_name, presence: {message: "can't be blank"} 
  validates :last_name, presence: {message: "can't be blank"}
  validates :first_name, uniqueness: { scope: [:last_name, :user_id], message: "and Last name already exist for this user" }
  validates :phone_number, format: { with: VALID_PHONE_REGEX, message: "must be in the format '555-555-5555'" }, allow_blank: true
  validates :email, format: { with: VALID_EMAIL_REGEX, message: "must be a valid email address" }, allow_blank: true
end
