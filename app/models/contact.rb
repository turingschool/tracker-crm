class Contact < ApplicationRecord
  belongs_to :user
  
  validates :first_name, presence: {message: "can't be blank"} 
  validates :last_name, presence: {message: "can't be blank"}
  validates :first_name, uniqueness: { scope: [:last_name, :user_id], message: "and Last name already exist for this user" }
end
