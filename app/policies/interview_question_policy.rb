class InterviewQuestionPolicy < ApplicationPolicy
  def index?
    admin? || user.present?
  end

  class Scope < Scope
    def resolve
      if admin?
        scope.all
      else
        scope.where(user: user)
      end
    end
  end
end
