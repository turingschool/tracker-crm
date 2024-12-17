class CompanyPolicy < ApplicationPolicy
  def create?
    user.present?
  end

  def show?
    admin? || user?
  end

  def index?
    user.present?
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      return scope.none unless user
      
      if admin?
        scope.all
      else
        scope.where(user_id: user.id)
      end
    end
  end
end
