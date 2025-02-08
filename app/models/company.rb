class Company < ApplicationRecord
  rolify strict: true
  belongs_to :user 
  has_many :contacts
  has_many :job_applications
  
  validates :name, presence: true, allow_blank: false
  validates :website, presence: true, allow_blank: false
  validates :street_address, presence: true, allow_blank: false
  validates :city, presence: true, allow_blank: false
  validates :state, presence: true, allow_blank: false
  validates :zip_code, presence: true, allow_blank: false
  validates :notes, presence: true, allow_nil: true
end
