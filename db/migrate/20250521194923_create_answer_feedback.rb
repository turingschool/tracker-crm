class CreateAnswerFeedback < ActiveRecord::Migration[7.1]
  def change
    create_table :answer_feedbacks do |t|
      t.references :interview_questions, null: false, foreign_key: true
      t.string :answer
      t.string :feedback

      t.timestamps
    end
  end
end
