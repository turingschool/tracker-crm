class UserPolicy < ApplicationPolicy
# Feel free to use this as a template for your own policies
# that you'll define and then will be used by their corresponding controller.

  def create?
    true
  end
  # anyone site visitor can #create a user

  def index?
    admin?
  end
  # only an admin can view all the users #index

  def show?
    admin? || user == record
  end
  # admin can see any user, a user can only see their own record/themselves #show

  def update?
    admin? || user == record
  end
  # admin can #update any user, a user can only #update their own record/themselves

  class Scope < ApplicationPolicy::Scope
    # NOTE: Be explicit about which records you allow access to!
    # Scope nested class defines which records a user is authorized to access when retrieving a collection of objects, such as in an index action.

    def resolve #resolve determines which records a user is allowed to access 
      if admin? #method inherited from ApplicationPolicy to check role of current user(:admin)
        scope.all
      elsif user?#method inherited from ApplicationPolicy to check role of current user(:user)
        scope.where(id: user.id) || scope.where(user_id: user.id)
      else
        scope.none
      end
    end
  end
end
