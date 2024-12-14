class JobApplicationPolicy < ApplicationPolicy

  def index?
    record.user_id == user.id
  end
  
  def create?
    record.user_id == user.id
  end

  def show?
    record.user_id == user.id
  end

  class Scope < ApplicationPolicy::Scope

    def resolve 
      if user?
        scope.where(user_id: user.id)
      else
        scope.none
      end
    end
  end
end
