class ModifyInterviewQuestions < ActiveRecord::Migration[7.1]
  def change
    remove_reference :interview_questions, :user, foreign_key: true
    add_reference :interview_questions, :job_application, null: false, foreign_key: true
  end
end
