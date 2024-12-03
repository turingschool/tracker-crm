class User < ApplicationRecord
  has_many :companies
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :password, presence: { require: true }
  has_secure_password
end
