class AnswerFeedback < ApplicationRecord
  belongs_to :interview_question

  validates :answer, presence: true
  validates :feedback, presence: true
end