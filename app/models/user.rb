class User < ApplicationRecord
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :password, presence: { require: true }
  has_secure_password

  has_many :contacts, dependent: :destroy
end
