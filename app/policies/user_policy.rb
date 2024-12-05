class UserPolicy < ApplicationPolicy
# Feel free to use this as a template for your own policies
# that will be used by their corresponding controller

  def create?
    admin?
  end
  # only an admin can create a user

  def index?
    admin?
  end
  # only an admin can view all the users

  def show?
    admin? || user == record
  end
  # admin can see any user, a user can only see their own record/themselves

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
