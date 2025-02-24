class AddUserIdToInterviewQuestions < ActiveRecord::Migration[7.1]
  def change
    add_reference :interview_questions, :user, null: false, foreign_key: true
  end
end
