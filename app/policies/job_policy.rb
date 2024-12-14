class JobPolicy < ApplicationPolicy

  def index?
    admin? || user == record
  end
  
  def create?
    user == record
  end

  def show?
    admin? || user == record
  end

  class Scope < ApplicationPolicy::Scope

    def resolve
      scope.all
    end
  end
end
