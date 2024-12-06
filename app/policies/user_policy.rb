class UserPolicy < ApplicationPolicy
# Feel free to use this as a template for your own policies
# that will be used by their corresponding controller

  def create?
    true
  end
  # anyone site visitor can create a user

  def index?
    admin?
  end
  # only an admin can view all the users

  def show?
    admin? || user == record
  end
  # admin can see any user, a user can only see their own record/themselves

  def update?
    admin? || user == record
  end
  # admin can update any user, a user can only update their own record/themselves

  class Scope < ApplicationPolicy::Scope
    # NOTE: Be explicit about which records you allow access to!
    def resolve
      if admin?
        scope.all
      elsif user?
        scope.where(id: user.id)
      else
        scope.none
      end
    end
  end
end
