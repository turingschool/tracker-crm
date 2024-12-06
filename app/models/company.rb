class Company < ApplicationRecord
  belongs_to :user 
  validates :name, presence: true
  validates :website, presence: true
  validates :street_address, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :zip_code, presence: true
end
