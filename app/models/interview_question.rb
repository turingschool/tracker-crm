class InterviewQuestion < ApplicationRecord
  belongs_to :job_application
  has_one :answer_feedback
end