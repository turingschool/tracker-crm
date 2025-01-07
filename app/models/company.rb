class Company < ApplicationRecord
  rolify strict: true
  belongs_to :user 
  has_many :contacts
  has_many :job_applications
  
  validates :name, presence: true
end
