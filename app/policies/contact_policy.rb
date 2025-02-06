class ContactPolicy < ApplicationPolicy

  def index?
    admin? || user.present?
  end

  def create?
    admin? || user.present?
  end

  def destroy?
    admin? || (user? && user.id == record.user_id)
  end

  class Scope < ApplicationPolicy::Scope

    def resolve
      if admin?
        scope.all
      elsif user?
        scope.where(user: user)
      else
        scope.none
      end
    end
  end
end
