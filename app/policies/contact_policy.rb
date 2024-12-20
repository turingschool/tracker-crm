class ContactPolicy < ApplicationPolicy

  def index?
    admin? || user.present?
  end

  def create?
    admin? || user.present?
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
