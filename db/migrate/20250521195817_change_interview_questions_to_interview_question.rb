class ChangeInterviewQuestionsToInterviewQuestion < ActiveRecord::Migration[7.1]
  def change
    rename_column :answer_feedbacks, :interview_questions_id, :interview_question_id
  end
end
