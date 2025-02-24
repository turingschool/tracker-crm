class CreateInterviewQuestions < ActiveRecord::Migration[7.1]
  def change
    create_table :interview_questions do |t|
      t.string :question

      t.timestamps
    end
  end
end
