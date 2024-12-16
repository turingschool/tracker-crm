class User < ApplicationRecord
  rolify strict: true

  has_many :companies, dependent: :destroy
  has_many :job_applications, dependent: :destroy
  has_many :contacts, dependent: :destroy
  
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :password, presence: { require: true }
  has_secure_password

  has_many :contacts, dependent: :destroy

  after_create :assign_default_role

  def assign_default_role
    set_role(:user) if roles.blank?
  end

  def is_admin?
    has_role?(:admin)
  end

  def is_user?
    has_role?(:user)
  end

  def set_role(role_name)
    self.roles.destroy_all
    self.add_role(role_name)
  end
end
