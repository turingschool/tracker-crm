class User < ApplicationRecord
  rolify

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :password, presence: { require: true }
  has_secure_password

  has_many :contacts, dependent: :destroy

  after_create :assign_default_role

  def assign_default_role
    self.add_role(:user) if self.roles.blank?
  end

  def is_admin?
    has_role?(:admin)
  end

  def is_user?
    has_role?(:user)
  end

  def assign_role(role_name, current_user)
    if current_user.has_role?(:admin)
      self.add_role(role_name)
    else
      raise StandardError, "Only admins can assign roles."
    end
  end
end
