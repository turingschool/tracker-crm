class InterviewQuestionPolicy < ApplicationPolicy
  def index?
    admin? || user.present?
  end

  def show?
    record.job_application.user_id == user.id
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
