class AnswerFeedbackPolicy < ApplicationPolicy
  def create?
    user.present? &&
      record.interview_question.present? &&
      record.interview_question.job_application.user_id == user.id
  end
end