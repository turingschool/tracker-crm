class CreateAnswerFeedbacks < ActiveRecord::Migration[7.1]
  def change
    create_table :answer_feedbacks do |t|
      t.references :interview_question, null: false, foreign_key: true
      t.text :answer
      t.text :feedback

      t.timestamps
    end
  end
end
