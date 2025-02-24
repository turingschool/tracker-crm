class InterviewQuestionPolicy < ApplicationPolicy
  def index?
    admin? || user.present?
  end
end