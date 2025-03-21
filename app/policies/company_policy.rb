class CompanyPolicy < ApplicationPolicy
  def create?
    user.present?
  end

  def show?
    return false unless user
    admin? || record.user_id == user.id
  end

  def index?
    user.present?
  end

  def update?
    return false unless user
    admin? || record.user_id == user.id
  end

  def destroy?
    return false unless user
    admin? || record.user_id == user.id
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
